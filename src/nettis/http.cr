require "http/client"
require "uri"
require "crest"

module Nettis
  module Http

    property uri
    property response

    def self.whois(domain)
      Nettis::Meta.p "Doing a whois on domain: #{domain} [using: #{Nettis::Nic::ENDPOINT}] ..."
      nic = Nettis::Nic.new
      nic.whois(domain)
    end

    def self.domains
      Nettis::Meta.p "Extracting domains [using: #{Nettis::Nic::ENDPOINT}] ..."
      nic = Nettis::Nic.new
      nic.last_five
    end

    # Run a process
    def self.run(cmd)
      o = IO::Memory.new
      Process.run(cmd, shell: true, output: o) 
      o.close
      o.to_s
    end

 end
end
