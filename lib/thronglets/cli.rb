# frozen_string_literal: true

require "thor"
require "irb"
require_relative "worker"
require_relative "listener"

class Thronglets::CLI < Thor
  extend Thronglets::ThorExt::Start

  map %w[-v --version] => "version"
  map %w[-w --worker] => "worker"
  map %w[-l --listen] => "listen"
  map %w[-c --console] => "console"

  desc "version", "Display thronglets version", hide: true
  def version
    say "thronglets/#{Thronglets::VERSION} #{RUBY_DESCRIPTION}"
  end

  desc "worker", "Start worker"
  def worker
    say "Starting worker"
    require File.join(Dir.pwd, "config", "temporal/env.rb")

    app = Thronglets::Worker.new
    app.run
  end

  desc "listen", "Start worker in listen mode"
  def listen
    say "Starting worker in listen mode"
    require File.join(Dir.pwd, "config", "temporal/env.rb")

    app = Thronglets::Listener.new
    app.run
  end

  desc "console", "Start console"
  def console
    say "Starting console"
    require File.join(Dir.pwd, "config", "temporal/env.rb")
    loader = Thronglets::Loader.new
    loader.load

    ARGV.clear # otherwise all script parameters get passed to IRB
    IRB.start
  end
end
