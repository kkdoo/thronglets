# frozen_string_literal: true

module Thronglets
  module Concerns
    module AbstractClass
      extend ActiveSupport::Concern

      class_methods do
        def abstract_class?
          defined?(@abstract_class) && @abstract_class == true
        end

        def abstract_class=(value)
          @abstract_class = value
        end
      end
    end
  end
end
