# frozen_string_literal: true

require "listen"
require "childprocess"

class Thronglets::Listener
  attr_reader :process

  def initialize
    @process = nil
  end

  def run
    spawn_process

    listener = Listen.to("app") do |_modified, _added, _removed|
      process.stop
    ensure
      spawn_process
    end
    listener.start
    sleep
  rescue Interrupt
    process.stop # tries increasingly harsher methods to kill the process.
  end

  private

    def spawn_process
      @process = ChildProcess.build("thronglets", "-w")
      process.io.inherit!
      process.start
    end
end
