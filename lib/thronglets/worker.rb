# frozen_string_literal: true

require "zeitwerk"
require "temporal"
require "temporal/worker"
require_relative "registry"

module Thronglets
  class Worker
    attr_reader :loader

    def initialize
      @loader = Zeitwerk::Loader.new
      [
        "app/activities",
        "app/actors",
        "app/workflows",
        "app/models",
        "app/models/concerns",
      ].each do |path|
        loader.push_dir(path)
      end
      loader.setup
    end

    def run
      registry.load!
      worker.start # runs forever
    end

    private

      def worker
        @worker ||= Temporal::Worker.new(
          ## how many threads poll for activities
          #activity_thread_pool_size: 20,
          ## how many threads poll for workflows
          #workflow_thread_pool_size: 10,
          ## identifies the version of workflow worker code
          #binary_checksum: nil,
          ## how many seconds to wait after unsuccessful poll for activities
          #activity_poll_retry_seconds: 0,
          ## how many seconds to wait after unsuccessful poll for workflows
          #workflow_poll_retry_seconds: 0,
          ## rate-limit for starting activity tasks (new activities + retries) on the task queue
          #activity_max_tasks_per_second: 0,
        )
      end

      def registry
        @registry ||= Thronglets::Registry.new(worker)
      end
  end
end
