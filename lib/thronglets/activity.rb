# frozen_string_literal: true

class Thronglets::Activity < Temporal::Activity
  include Thronglets::Concerns::AbstractClass

  attr_reader :params

  def call
    raise "NotImplemented"
  end

  def execute(args)
    @params = args.as_json

    call
  end
end
