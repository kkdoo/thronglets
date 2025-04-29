# frozen_string_literal: true

module Thronglets
  class Workflow < Temporal::Workflow
    include Concerns::AbstractClass

    attr_reader :params

    def call
      raise "NotImplemented"
    end

    def execute(args)
      validate_input!(args)

      call
    rescue ValidationError => e
      {
        errors: e.errors,
      }.as_json
    end

    class ValidationError < StandardError
      attr_reader :errors

      def initialize(errors)
        @errors = errors
        super("Parameters are not valid")
      end
    end

    protected

      attr_reader :input_errors, :input_result

      class << self
        def input(&)
          @input = Dry::Schema.Params(&)
        end

        def input_schema
          @input
        end
      end

      def validate_input!(args)
        @input_result = input_schema.call(args)
        @params = input_result.to_h
        @input_errors = input_result.errors.to_h
        return unless input_errors.present?

        raise ValidationError, input_errors
      end

      def input_schema
        self.class.input_schema
      end
  end
end
