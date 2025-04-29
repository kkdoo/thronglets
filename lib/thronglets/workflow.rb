# frozen_string_literal: true

module Thronglets
  class Workflow < Temporal::Workflow
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

      def self.input(&block)
        @input = Dry::Schema.Params(&block)
      end

      def validate_input!(args)
        @input_result = input_schema.call(args)
        @params = input_result.to_h
        @input_errors = input_result.errors.to_h
        if input_errors.present?
          raise ValidationError.new(input_errors)
        end
      end

      def self.input_schema
        @input
      end

      def input_schema
        self.class.input_schema
      end
  end
end
