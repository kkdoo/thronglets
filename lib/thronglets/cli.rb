# frozen_string_literal: true

require "thor"
require_relative "worker"
require_relative "listener"

class Thronglets::CLI < Thor
  extend Thronglets::ThorExt::Start

  map %w[-v --version] => "version"
  map %w[-w --worker] => "worker"
  map %w[-l --listen] => "listen"

  desc "version", "Display thronglets version", hide: true
  def version
    say "thronglets/#{Thronglets::VERSION} #{RUBY_DESCRIPTION}"
  end

  desc "worker", "Start worker"
  def worker
    say "start worker"
    require File.join(Dir.pwd, 'config', 'temporal/env.rb')

    app = Thronglets::Worker.new
    app.run
  end

  desc "listen", "Start worker in listen mode"
  def listen
    say "start worker in listen mode"
    require File.join(Dir.pwd, 'config', 'temporal/env.rb')

    app = Thronglets::Listener.new
    app.run
  end
end
