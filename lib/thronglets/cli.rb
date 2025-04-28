# frozen_string_literal: true

require "thor"

module Thronglets
  class CLI < Thor
    extend ThorExt::Start

    map %w[-v --version] => "version"

    desc "version", "Display thronglets version", hide: true
    def version
      say "thronglets/#{VERSION} #{RUBY_DESCRIPTION}"
    end
  end
end
