# frozen_string_literal: true

require "temporalio/client"
require "temporalio/worker"
require_relative "registry"

class Thronglets::Worker
  attr_reader :loader, :activities, :workflows

  def initialize
    @loader = Thronglets::Loader.new
  end

  def run
    loader.load
    registry.load!
    worker.run(shutdown_signals: %w[ SIGINT SIGTERM ])
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

    def client
      @client ||= begin
        client = Thronglets::Env.client(max_retries: worker_max_retries)
        puts "Connected to Temporal"
        client
      end
    rescue Thronglets::Env::MaxRetriesExceededError => e
      puts e.message
      puts "Exiting..."
      Kernel.exit(false)
    end

    def worker
      @worker ||= Temporalio::Worker.new(
        client:,
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

    def worker_max_retries
      @worker_max_retries ||= ENV.fetch("TLET_WORKER_MAX_RETRIES", 10)
    end
end
