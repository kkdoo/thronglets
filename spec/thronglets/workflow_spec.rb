# frozen_string_literal: true

require "spec_helper"

RSpec.describe Thronglets::Workflow do
  # Create a test workflow class
  let(:test_workflow_class) do
    Class.new(described_class) do
      input do
        required(:name).filled(:string)
        required(:age).filled(:integer)
      end

      output do
        required(:success).filled(:bool)
        required(:message).filled(:string)
      end

      def call
        {
          success: true,
          message: "Hello #{params["name"]}, you are #{params["age"]} years old!"
        }
      end
    end
  end

  let(:workflow) { test_workflow_class.new(self) }
  let(:valid_input) { { name: "John", age: 30 } }
  let(:invalid_input) { { name: nil, age: "invalid" } }
  let(:valid_output) { { success: true, message: "Hello John, you are 30 years old!" } }
  let(:invalid_output) { { success: "not_boolean", message: nil } }

  describe "#execute" do
    context "with valid input and output" do
      it "processes the workflow successfully" do
        result = workflow.execute(valid_input)
        expect(result).to eq(valid_output.as_json)
      end

      it "sets the params attribute" do
        workflow.execute(valid_input)
        expect(workflow.params).to eq(valid_input.as_json)
      end
    end

    context "with invalid input" do
      it "returns error hash" do
        result = workflow.execute(invalid_input)
        expect(result["errors"]).to be_present
        expect(result["errors"]).to include("name", "age")
      end
    end

    context "with invalid output" do
      let(:test_workflow_class) do
        Class.new(described_class) do
          input do
            required(:name).filled(:string)
            required(:age).filled(:integer)
          end

          output do
            required(:success).filled(:bool)
            required(:message).filled(:string)
          end

          def call
            { success: "not_boolean", message: nil }
          end
        end
      end

      it "returns error hash" do
        result = workflow.execute(valid_input)
        expect(result["errors"]).to be_present
        expect(result["errors"]).to include("success", "message")
      end
    end
  end

  describe "#call" do
    context "when not implemented in subclass" do
      let(:test_workflow_class) { Class.new(described_class) }

      it "raises NotImplemented error" do
        expect { workflow.call }.to raise_error("NotImplemented")
      end
    end
  end

  describe ".abstract_class?" do
    context "when class is marked as abstract" do
      let(:abstract_workflow) do
        Class.new(described_class) do
          self.abstract_class = true
        end
      end

      it "returns true" do
        expect(abstract_workflow.abstract_class?).to be true
      end
    end

    context "when class is not marked as abstract" do
      it "returns false" do
        expect(test_workflow_class.abstract_class?).to be false
      end
    end
  end
end 