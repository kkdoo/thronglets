# frozen_string_literal: true

module Thronglets
  class Registry
    attr_reader :worker

    def initialize(worker)
      @worker = worker
    end

    def load!
      list_classes_in_dir("app/activities").each do |activity|
        if can_register_class?(activity)
          puts "Registered: %s" % activity
          worker.register_activity(activity)
        end
      end
      list_classes_in_dir("app/workflows").each do |workflow|
        if can_register_class?(workflow)
          puts "Registered: %s" % workflow
          worker.register_workflow(workflow)
        end
      end
    end

    private

      def list_classes_in_dir(path)
        Dir.glob("#{path}/**/*.{rb}").map do |file|
          name = file.delete_prefix("#{path}/").delete_suffix(".rb")
          name.camelize.constantize
        end
      end

      def can_register_class?(klass)
        !klass.abstract_class?
      end
  end
end
