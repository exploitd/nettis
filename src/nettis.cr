require "./nettis/version"
require "./nettis/scanner"
require "./nettis/http"
require "./nettis/meta"
require "./nettis/cli"
require "./nettis/source/nic"

require "http"
require "crystagiri"
require "terminal_table"

module Nettis 
  class Kernel

    getter :cli

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

      Nettis::Meta.p "Welcome to nettis! v#{Nettis::VERSION} --Zone builder for .BA domains\n" 
    end

    def cli 
      Nettis::Cli.new
    end

  end
end

nettis = Nettis::Kernel.new
nettis.hey
nettis.cli
