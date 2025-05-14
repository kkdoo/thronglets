# frozen_string_literal: true

module Thronglets::Concerns::AbstractClass
  extend ::ActiveSupport::Concern

  class_methods do
    def abstract_class?
      !!(defined?(@abstract_class) && @abstract_class)
    end

    def abstract_class=(value)
      @abstract_class = value
    end
  end
end
