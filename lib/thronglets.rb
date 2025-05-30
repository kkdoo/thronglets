# frozen_string_literal: true

require "bundler"
Bundler.require(:default)
require "active_support/all"

module Thronglets
  module ThorExt
    autoload :Start, "thronglets/thor_ext/start"
  end

  module Concerns
    autoload :AbstractClass, "thronglets/concerns/abstract_class"
    autoload :Output, "thronglets/concerns/output"
    autoload :Input, "thronglets/concerns/input"
  end

  autoload :CLI, "thronglets/cli"
  autoload :VERSION, "thronglets/version"
  autoload :Workflow, "thronglets/workflow"
  autoload :Activity, "thronglets/activity"
  autoload :Loader, "thronglets/loader"
  autoload :Registry, "thronglets/registry"
  autoload :Worker, "thronglets/worker"
end
