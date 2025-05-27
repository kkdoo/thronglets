# frozen_string_literal: true

require "temporalio/workflow"
require "dry-schema"

class Thronglets::Workflow < Temporalio::Workflow::Definition
  include Thronglets::Concerns::AbstractClass
  include Thronglets::Concerns::Input
  include Thronglets::Concerns::Output

  attr_reader :params

  def self.execute(workflow_name, *, options: {})
    options[:id] ||= SecureRandom.uuid
    options[:task_queue] ||= ENV.fetch("TLET_QUEUE", "default")

    Thronglets::Env.client.execute_workflow(
      workflow_name,
      *,
      **options,
    )
  end

  def call
    raise "NotImplemented"
  end

  def execute(args)
    Temporalio::Workflow::Unsafe.illegal_call_tracing_disabled do
      @params = validate_input!(args.as_json)
    end

    data = call.as_json

    Temporalio::Workflow::Unsafe.illegal_call_tracing_disabled do
      @_result = if output_schema
        validate_output!(data)
      else
        data
      end
    end

    @_result
  rescue InputValidationError, OutputValidationError => e
    {
      errors: e.errors,
    }.as_json
  end

  protected

    def execute_activity(activity_name, *, options: {})
      options[:schedule_to_close_timeout] ||= 30.seconds

      Temporalio::Workflow.execute_activity(
        activity_name,
        *,
        **options,
      )
    end

  private

    def parsed_args(args)
      JSON.parse(args)
    rescue JSON::ParserError
      args
    end
end
