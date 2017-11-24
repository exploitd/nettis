require "commander"

module Nettis
 class Cli

    property  :tty

    def initialize

      @tty = Commander::Command.new do |cmd|

        cmd.use = "nettis"

        cmd.run do |options, arguments|
          #p arguments             # => Array(String)
          puts cmd.help           # => Render help screen
        end

        cmd.commands.add do |cmd|
          cmd.use = "last <#>"
          cmd.short = "Show last (max) 5 domains registered in zone."
          cmd.long = cmd.short
          cmd.run do |options, arguments|
            exit if arguments.empty?
            Nettis::Scanner.new.find_(arguments[0].to_i)
          end
        end

        cmd.commands.add do |cmd|
          cmd.use = "whois <domain>"
          cmd.short = "Execute a whois on domain and OCR-to-ASCII."
          cmd.long = cmd.short
          cmd.run do |options, arguments|
            arguments # => ["https://github.com/duraki"]
          end
        end

        cmd.commands.add do |cmd|
          cmd.use = "about"
          cmd.short = "Show information about `nettis` and how it's used."
          cmd.long = cmd.short
          cmd.run do |options, arguments|
            arguments 
          end
        end
      end

      Commander.run(@tty, ARGV)
    end

    def tty
      @tty
    end

 end
end
