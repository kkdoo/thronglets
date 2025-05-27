# frozen_string_literal: true

require "temporalio/client"

class Thronglets::Env
  class MaxRetriesExceededError < StandardError; end

  def initialize
    @env_name = ENV.fetch("TLET_ENV", "development")
  end

  def client(options = {}, &)
    options[:max_retries] ||= default_max_retries
    retry_count ||= 0

    @client ||= Temporalio::Client.connect(
      connection_string,
      namespace,
      data_converter: Temporalio::Converters::DataConverter.default,
    )

    yield(@client) if block_given?

    @client
  rescue Temporalio::Internal::Bridge::Error => e
    puts "Error connecting to Temporal"
    puts e.message
    retry_count += 1

    if retry_count > options[:max_retries]
      raise MaxRetriesExceededError, "Max retries exceeded"
    end

    puts "Retrying in 5 seconds..."
    sleep 5
    retry
  end

  def self.instance
    @instance ||= new
  end

  def self.client(options = {})
    @client ||= instance.client(options)
  end

  def namespace
    @namespace ||= ENV.fetch("TLET_NAMESPACE", "default")
  end

  def connection_string
    @connection_string ||= "#{host}:#{port}"
  end

  def host
    @host ||= ENV.fetch("TLET_HOST", "localhost")
  end

  def port
    @port ||= ENV.fetch("TLET_PORT", "7233")
  end

  def default_max_retries
    @default_max_retries ||= ENV.fetch("TLET_MAX_RETRIES", 3)
  end
end
