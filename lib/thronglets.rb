# frozen_string_literal: true

module Thronglets
  module ThorExt
    autoload :Start, "thronglets/thor_ext/start"
  end

  module Concerns
    autoload :AbstractClass, "thronglets/concerns/abstract_class"
  end

  autoload :CLI, "thronglets/cli"
  autoload :VERSION, "thronglets/version"
  autoload :Workflow, "thronglets/workflow"
  autoload :Activity, "thronglets/activity"
  autoload :Loader, "thronglets/loader"
end
