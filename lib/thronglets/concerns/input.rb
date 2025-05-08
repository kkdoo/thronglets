# frozen_string_literal: true

module Thronglets::Concerns::Input
  extend ActiveSupport::Concern

  attr_reader :input_errors, :input_result

  delegate :input_schema, to: :class

  class_methods do
    def input(&)
      @input = Dry::Schema.Params(&)
    end

    def input_schema
      @input
    end
  end

  class InputValidationError < StandardError
    attr_reader :errors

    def initialize(errors)
      @errors = errors
      super("Parameters are not valid")
    end
  end

  def validate_input!(args)
    return args unless input_schema

    @input_result = input_schema.call(args)
    input_result_data = input_result.to_h.as_json
    @input_errors = input_result.errors.to_h
    return input_result_data if input_errors.blank?

    raise InputValidationError, input_errors
  end
end
