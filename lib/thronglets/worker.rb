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
        loader.push_dir(path) if Dir.exist?(path)
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
end
