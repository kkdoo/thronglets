# frozen_string_literal: true

require "zeitwerk"
require "temporal"
require "temporal/worker"
require_relative "registry"

class Thronglets::Worker
  attr_reader :loader

  def initialize
    @loader = Thronglets::Loader.new
    loader.load
  end

  def run
    registry.load!
    worker.start # runs forever
  end

  private

    def worker
      @worker ||= Temporal::Worker.new(
        # how many threads poll for activities
        activity_thread_pool_size: 20,
        # how many threads poll for workflows
        workflow_thread_pool_size: 10,
      )
    end

    def registry
      @registry ||= Thronglets::Registry.new(worker)
    end
end
