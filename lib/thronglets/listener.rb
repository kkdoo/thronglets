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

    subscribe_listener
    loop do
      process.wait
      puts "Process exited with code #{process.exit_code}"
      puts "Restarting..."
      spawn_process
      sleep 5
    end
  rescue Interrupt
    puts "Interrupted"
    process.stop # tries increasingly harsher methods to kill the process.
  end

  private

    def subscribe_listener
      listener = Listen.to("app") do |_modified, _added, _removed|
        process.stop
      end
      listener.start
    end

    def spawn_process
      puts "Spawning process..."
      @process = ChildProcess.build("bundle", "exec", "thronglets", "-w")
      process.io.inherit!
      process.start
    end
end
