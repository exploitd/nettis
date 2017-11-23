require "./nettis/version"
require "./nettis/scanner"
require "./nettis/meta"

require "http"
require "crystagiri"
require "terminal_table"

module Nettis 
  class Kernel

    def hey
      print <<-'EOF'

                             /$$     /$$     /$$          
                            | $$    | $$    |__/          
       /$$$$$$$   /$$$$$$  /$$$$$$ /$$$$$$   /$$  /$$$$$$$
      | $$__  $$ /$$__  $$|_  $$_/|_  $$_/  | $$ /$$_____/
      | $$  \ $$| $$$$$$$$  | $$    | $$    | $$|  $$$$$$ 
      | $$  | $$| $$_____/  | $$ /$$| $$ /$$| $$ \____  $$
      | $$  | $$|  $$$$$$$  |  $$$$/|  $$$$/| $$ /$$$$$$$/
      |__/  |__/ \_______/   \___/   \___/  |__/|_______/ 

      EOF

      Nettis::Meta.p "Welcome to Nettis! v#{Nettis::VERSION} --Zone builder for .BA domains" 
    end

    def help
      cmds = TerminalTable.new
      cmds.headings = ["COMMAND", "ARGS", "RULE"]
      cmds << ["last", "[#]", "Show last (max) 5 domains in zone"]
      cmds << ["finger", "[domain]", "Whois domain and write textual from image"]
      cmds << ["help", "", "Show this info"]
      cmds << ["about", "", "Show about Nettis"]

      puts cmds.render
    end

    def initialize
    end

  end
end

cli = Nettis::Kernel.new
cli.hey
cli.help
