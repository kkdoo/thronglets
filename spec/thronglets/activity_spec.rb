# frozen_string_literal: true

require "spec_helper"

RSpec.describe Thronglets::Activity do
  # Create a test activity class
  let(:test_activity_class) do
    Class.new(described_class) do
      input do
        required(:user_id).filled(:integer)
        required(:action).filled(:string)
      end

      output do
        required(:status).filled(:string)
        required(:result).hash
      end

      def call
        {
          status: "completed",
          result: {
            user_id: params["user_id"],
            action: params["action"],
            timestamp: Time.now.iso8601
          }
        }
      end
    end
  end

  let(:activity) { test_activity_class.new(self) }
  let(:valid_input) { { user_id: 123, action: "test_action" } }
  let(:invalid_input) { { user_id: "invalid", action: nil } }
  let(:valid_output) do
    {
      status: "completed",
      result: {
        user_id: 123,
        action: "test_action",
        timestamp: Time.now.iso8601
      }
    }
  end

  describe "#execute" do
    context "with valid input and output" do
      it "processes the activity successfully" do
        result = activity.execute(valid_input)
        expect(result["status"]).to eq("completed")
        expect(result["result"]["user_id"]).to eq(123)
        expect(result["result"]["action"]).to eq("test_action")
        expect(result["result"]["timestamp"]).to be_present
      end

      it "sets the params attribute" do
        activity.execute(valid_input)
        expect(activity.params).to eq(valid_input.as_json)
      end
    end

    context "with invalid input" do
      it "returns error hash" do
        result = activity.execute(invalid_input)
        expect(result["errors"]).to be_present
        expect(result["errors"]).to include("user_id", "action")
      end
    end

    context "with invalid output" do
      let(:test_activity_class) do
        Class.new(described_class) do
          input do
            required(:user_id).filled(:integer)
            required(:action).filled(:string)
          end

          output do
            required(:status).filled(:string)
            required(:result).hash
          end

          def call
            { status: nil, result: "not_a_hash" }
          end
        end
      end

      it "returns error hash" do
        result = activity.execute(valid_input)
        expect(result["errors"]).to be_present
        expect(result["errors"]).to include("status", "result")
      end
    end
  end

  describe "#call" do
    context "when not implemented in subclass" do
      let(:test_activity_class) { Class.new(described_class) }

      it "raises NotImplemented error" do
        expect { activity.call }.to raise_error("NotImplemented")
      end
    end
  end

  describe ".abstract_class?" do
    context "when class is marked as abstract" do
      let(:abstract_activity) do
        Class.new(described_class) do
          self.abstract_class = true
        end
      end

      it "returns true" do
        expect(abstract_activity.abstract_class?).to be true
      end
    end

    context "when class is not marked as abstract" do
      it "returns false" do
        expect(test_activity_class.abstract_class?).to be false
      end
    end
  end

  describe "temporal integration" do
    it "inherits from Temporal::Activity" do
      expect(described_class.ancestors).to include(Temporal::Activity)
    end
  end
end 