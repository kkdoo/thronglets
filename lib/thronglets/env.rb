# frozen_string_literal: true

require "temporalio/client"

class Thronglets::Env
  def initialize
    @env_name = ENV.fetch("TLET_ENV", "development")
  end

  def client
    @client ||= Temporalio::Client.connect(
      connection_string,
      namespace,
      data_converter: Temporalio::Converters::DataConverter.default,
    )
  end

  def self.instance
    @instance ||= new
  end

  def self.client
    @client ||= instance.client
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
end
