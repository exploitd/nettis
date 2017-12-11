require "http/client"
require "uri"
require "crest"

module Nettis
  
  # Module HTTP instance of nettis. This module is used to manipulate with HTTP
  # service. We can use is to extract different part of ps available. 
  # 
  # @author Halis Duraki <duraki@linuxmail.org>
  # @attr [URI] uri encoded URI
  # @attr [Response] response http response[s]
  module Http

    property uri
    property response

    # Execute a whois on domain using a service that resolves to TLD.
    #
    # @param [String] domain HTTP domain
    # @return [Object]
    def self.whois(domain)
      Nettis::Meta.p "Doing a whois on domain: #{domain} [using: #{Nettis::Nic::ENDPOINT}] ..."
      nic = Nettis::Nic.new
      nic.whois(domain)
    end

    # Get last registered domains on zone for which nettis is configured for.
    #
    # @return [Object]
    def self.domains
      Nettis::Meta.p "Extracting domains [using: #{Nettis::Nic::ENDPOINT}] ..."
      nic = Nettis::Nic.new
      nic.last_five
    end

    # Get last domains database status on zone for which nettis is configured for.
    #
    # @return [Object]
    def self.status
      Nettis::Meta.p "Extracting domain status [using: #{Nettis::Nic::ENDPOINT}] ..."
      nic = Nettis::Nic.new
      nic.status
    end

 end
end
