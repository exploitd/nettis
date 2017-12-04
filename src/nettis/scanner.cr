require "crystagiri"

module Nettis

  # Abstract base class for SCANNER. Provides point to induce any command line
  # action. At the end of this document is definition of different nodes.
  # 
  # @author Halis Duraki <duraki@linuxmail.org>
  # @attr [Request] req request action callback
  # @attr [String]  cookie cookie token[s]
  # @attr [Array] ext_zone a list of extension zones at the top of TLD
  # @attr [Array] domains list of string of domain names
  class Scanner

    property :req
    property cookie= String.new # => Global cookie

    def initialize
      @ext_zone = Array(Int32).new
      @domains = Array(String).new
    end

    # Execute `whois` on given domain. Whois is described as an action or query
    # that is used for storing registered user or assignees of an Internet
    # resource. Use this action to induce different mods - domain whois, IP
    # whois, etc.
    # @see [whois]
    #
    # @param [String] domain
    # @return [Object]
    def get_whois(domain)
      c = Nettis::Http.whois(domain)
    end

    # Execute `get domains` on a possible sources. 
    # @see [ps]
    # 
    # @return [Object]
    def get_domains
      c = Nettis::Http.domains
    end

    # @def.ps
    # Possible sources are defined as a way to entry point from one can extract actions.

    # @def.whois
    # Query and response protocol that is widely used for querying databases that store 
    # the registered users or assignees of an Internet resource, such as a 
    # domain name, an IP address block
  end
end
