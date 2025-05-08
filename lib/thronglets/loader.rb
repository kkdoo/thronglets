# frozen_string_literal: true

class Thronglets::Loader
  attr_reader :loader

  def initialize
    @loader = Zeitwerk::Loader.new
    [
      "app/activities",
      "app/actors",
      "app/workflows",
      "app/models",
      "app/models/concerns",
    ].each do |path|
      loader.push_dir(path) if Dir.exist?(path)
    end
  end

  def load
    loader.setup
  end
end
