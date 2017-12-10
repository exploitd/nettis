require "./nettis/version"
require "./nettis/scanner"
require "./nettis/http"
require "./nettis/meta"
require "./nettis/cli"
require "./nettis/source/nic"
require "./nettis/record/parse/nic/parser"

# => Exceptions
require "./nettis/exceptions/html"

# => Dependencies
require "http"
require "crystagiri"
require "terminal_table"

# Load & initialize kernel module. Creates a CLI instance for usage.
module Nettis 

  # Kernel class for nettis. Used only to initialize an entry point.
  class Kernel

    getter :cli

    APPLICATION_NAME = "nettis"
    APPLICATION_DESC = "Shodan for Bosnia and Herzegovina!"

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
