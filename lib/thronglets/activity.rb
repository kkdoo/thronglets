# frozen_string_literal: true

module Thronglets
  class Activity < Temporal::Activity
    include Concerns::AbstractClass

    attr_reader :params

    def call
      raise "NotImplemented"
    end

    def execute(args)
      @params = args

      call
    end
  end
end
