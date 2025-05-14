# frozen_string_literal: true

require "spec_helper"

RSpec.describe Thronglets::Registry do
  let(:worker) { instance_double("Temporal::Worker") }
  let(:registry) { described_class.new(worker) }

  # Test activities
  let(:abstract_activity) do
    Class.new(Thronglets::Activity) do
      self.abstract_class = true
    end
  end

  let(:concrete_activity) do
    Class.new(Thronglets::Activity) do
      def self.name
        "TestActivity"
      end
    end
  end

  # Test workflows
  let(:abstract_workflow) do
    Class.new(Thronglets::Workflow) do
      self.abstract_class = true
    end
  end

  let(:concrete_workflow) do
    Class.new(Thronglets::Workflow) do
      def self.name
        "TestWorkflow"
      end
    end
  end

  describe "#initialize" do
    it "sets the worker" do
      expect(registry.worker).to eq(worker)
    end
  end

  describe "#load!" do
    before do
      allow(worker).to receive(:register_activity)
      allow(worker).to receive(:register_workflow)
      
      # Mock list_classes_in_dir for both activities and workflows
      allow(registry).to receive(:list_classes_in_dir).with("app/activities").and_return([concrete_activity])
      allow(registry).to receive(:list_classes_in_dir).with("app/workflows").and_return([concrete_workflow])
    end

    it "registers non-abstract activities" do
      expect(worker).to receive(:register_activity).with(concrete_activity)
      registry.load!
    end

    it "registers non-abstract workflows" do
      expect(worker).to receive(:register_workflow).with(concrete_workflow)
      registry.load!
    end

    context "with abstract classes" do
      before do
        allow(registry).to receive(:list_classes_in_dir).with("app/activities").and_return([abstract_activity])
        allow(registry).to receive(:list_classes_in_dir).with("app/workflows").and_return([abstract_workflow])
      end

      it "does not register abstract activities" do
        expect(worker).not_to receive(:register_activity)
        registry.load!
      end

      it "does not register abstract workflows" do
        expect(worker).not_to receive(:register_workflow)
        registry.load!
      end
    end

    context "with empty directories" do
      before do
        allow(registry).to receive(:list_classes_in_dir).and_return([])
      end

      it "handles empty activity directory" do
        expect(worker).not_to receive(:register_activity)
        registry.load!
      end

      it "handles empty workflow directory" do
        expect(worker).not_to receive(:register_workflow)
        registry.load!
      end
    end

    context "with mixed classes" do
      before do
        allow(registry).to receive(:list_classes_in_dir).with("app/activities").and_return([abstract_activity, concrete_activity])
        allow(registry).to receive(:list_classes_in_dir).with("app/workflows").and_return([abstract_workflow, concrete_workflow])
      end

      it "registers only non-abstract classes" do
        expect(worker).to receive(:register_activity).with(concrete_activity)
        expect(worker).to receive(:register_workflow).with(concrete_workflow)
        registry.load!
      end
    end
  end

  describe "#can_register_class?" do
    it "returns true for non-abstract classes" do
      expect(registry.send(:can_register_class?, concrete_activity)).to be true
      expect(registry.send(:can_register_class?, concrete_workflow)).to be true
    end

    it "returns false for abstract classes" do
      expect(registry.send(:can_register_class?, abstract_activity)).to be false
      expect(registry.send(:can_register_class?, abstract_workflow)).to be false
    end
  end

  describe "#list_classes_in_dir" do
    let(:test_path) { "app/test_dir" }
    let(:test_files) { ["app/test_dir/foo.rb", "app/test_dir/bar.rb"] }

    before do
      allow(Dir).to receive(:glob).with("#{test_path}/**/*.{rb}").and_return(test_files)
      allow_any_instance_of(String).to receive(:constantize).and_return(concrete_activity)
    end

    it "converts file paths to class names" do
      classes = registry.send(:list_classes_in_dir, test_path)
      expect(classes).to all(be_a(Class))
      expect(classes.size).to eq(test_files.size)
    end

    context "with nested directories" do
      let(:test_files) { ["app/test_dir/nested/foo.rb", "app/test_dir/deeply/nested/bar.rb"] }

      it "handles nested directories correctly" do
        classes = registry.send(:list_classes_in_dir, test_path)
        expect(classes).to all(be_a(Class))
        expect(classes.size).to eq(test_files.size)
      end
    end
  end
end 