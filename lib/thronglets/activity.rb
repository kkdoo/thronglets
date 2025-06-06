# frozen_string_literal: true

require "temporalio/activity"
require "dry-schema"

class Thronglets::Activity < Temporalio::Activity::Definition
  include Thronglets::Concerns::AbstractClass
  include Thronglets::Concerns::Input
  include Thronglets::Concerns::Output

  attr_reader :params

  def call
    raise "NotImplemented"
  end

  def execute(args)
    @params = validate_input!(args.as_json)

    data = call.as_json

    if output_schema
      validate_output!(data)
    else
      data
    end
  rescue InputValidationError, OutputValidationError => e
    {
      errors: e.errors,
    }.as_json
  end
end
