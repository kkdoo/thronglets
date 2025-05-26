# frozen_string_literal: true

require "temporalio/client"
require "temporalio/worker"
require_relative "registry"

class Thronglets::Worker
  attr_reader :loader, :activities, :workflows

  def initialize
    @loader = Thronglets::Loader.new
    loader.load
  end

  def run
    registry.load!
    worker.run(shutdown_signals: [ "SIGINT" ])
  end

  def register_activity(activity)
    @activities ||= []
    @activities << activity
  end

  def register_workflow(workflow)
    @workflows ||= []
    @workflows << workflow
  end

  private

    def worker
      @worker ||= Temporalio::Worker.new(
        client: Thronglets::Env.client,
        task_queue:,
        activities:,
        workflows:,
      )
    end

    def registry
      @registry ||= Thronglets::Registry.new(self)
    end

    def task_queue
      @task_queue ||= ENV.fetch("TLET_QUEUE", "default")
    end
end
