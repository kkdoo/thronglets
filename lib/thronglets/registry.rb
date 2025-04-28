# frozen_string_literal: true

module Thronglets
  class Registry
    attr_reader :worker

    def initialize(worker)
      @worker = worker
    end

    def load!
      list_classes_in_dir("app/activities").each do |activity|
        pp activity
        worker.register_activity(activity)
      end
      list_classes_in_dir("app/workflows").each do |workflow|
        pp workflow
        worker.register_workflow(workflow)
      end
    end

    private

      def list_classes_in_dir(path)
        Dir.glob("#{path}/**/*.{rb}").map do |file|
          name = file.delete_prefix("#{path}/").delete_suffix(".rb")
          name.camelize.constantize
        end
      end
  end
end
