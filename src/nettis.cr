require "./nettis/scanner"
require "./nettis/meta"

require "http"
require "crystagiri"
require "terminal_table"

module Nettis 
  class Kernel

    def hey
      Nettis::Meta.p "Welcome to Nettis! --Zone builder for .BA domains" 
    end

    def help
      cmds = TerminalTable.new
      cmds.headings = ["COMMAND", "ARGS", "RULE"]
      cmds << ["last", "[#num]", "Get last (max) 5 domains from UTIC"]
      cmds << ["finger", "[domain]", "Whois domain and write textual from image"]

      puts cmds.render
    end

    def initialize
    end

  end
end

cli = Nettis::Kernel.new
cli.hey
cli.help
