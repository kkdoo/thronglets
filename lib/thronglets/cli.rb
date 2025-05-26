# frozen_string_literal: true

require "bundler"
Bundler.require(:default)
require "thor"
require "irb"
require_relative "worker"
require_relative "listener"

class Thronglets::CLI < Thor
  extend Thronglets::ThorExt::Start

  map %w[-v --version] => "version"
  map %w[-w --worker] => "worker"
  map %w[-d --dev] => "dev"
  map %w[-c --console] => "console"

  desc "version", "Display thronglets version", hide: true
  def version
    say "thronglets/#{Thronglets::VERSION} #{RUBY_DESCRIPTION}"
  end

  desc "worker", "Start worker"
  option :env, type: :string
  option :config, type: :string
  option :host, type: :string
  option :port, type: :string
  option :namespace, type: :string
  option :queue, type: :string
  def worker
    say "Starting worker"
    load_options

    app = Thronglets::Worker.new
    app.run
  end

  desc "dev", "Start in dev mode"
  def dev
    say "Starting in dev mode"
    app = Thronglets::Listener.new
    app.run
  end

  desc "console", "Start console"
  option :env, type: :string
  option :config, type: :string
  option :host, type: :string
  option :port, type: :string
  option :namespace, type: :string
  option :queue, type: :string
  def console
    say "Starting console"
    load_options

    loader = Thronglets::Loader.new
    loader.load

    ARGV.clear # otherwise all script parameters get passed to IRB
    IRB.start
  end

  private

    def load_options
      ENV["TLET_ENV"] = options[:env] || ENV.fetch("TLET_ENV", "development")
      ENV["TLET_CONFIG"] = options[:config] || ENV.fetch("TLET_CONFIG", "config/thronglets.rb")
      ENV["TLET_HOST"] = options[:host] || ENV.fetch("TLET_HOST", "localhost")
      ENV["TLET_PORT"] = options[:port] || ENV.fetch("TLET_PORT", "7233")
      ENV["TLET_NAMESPACE"] = options[:namespace] || ENV.fetch("TLET_NAMESPACE", "default")
      ENV["TLET_QUEUE"] = options[:queue] || ENV.fetch("TLET_QUEUE", "default")

      say "Using env: #{ENV.fetch("TLET_ENV")}"
      say "Using host: #{ENV.fetch("TLET_HOST")}"
      say "Using port: #{ENV.fetch("TLET_PORT")}"
      say "Using namespace: #{ENV.fetch("TLET_NAMESPACE")}"
      say "Using queue: #{ENV.fetch("TLET_QUEUE")}"
      require_relative "env"
      if File.exist?(ENV.fetch("TLET_CONFIG"))
        say "Loading config from '#{ENV.fetch("TLET_CONFIG")}'"
        require File.join(Dir.pwd, ENV.fetch("TLET_CONFIG"))
      else
        say "Config file '#{ENV.fetch("TLET_CONFIG")}' not found"
      end
    end
end
