# frozen_string_literal: true

module Thronglets::Concerns::Output
  extend ActiveSupport::Concern

  attr_reader :output_errors, :output_result

  delegate :output_schema, to: :class

  class_methods do
    def output(&)
      @output = Dry::Schema.Params(&)
    end

    def output_schema
      @output
    end
  end

  class OutputValidationError < StandardError
    attr_reader :errors

    def initialize(errors)
      @errors = errors
      super("Results are not valid")
    end
  end

  def validate_output!(data)
    @output_result = output_schema.call(data)
    output_result_data = output_result.to_h.as_json
    @output_errors = output_result.errors.to_h
    return output_result_data if output_errors.blank?

    raise OutputValidationError, output_errors
  end
end
