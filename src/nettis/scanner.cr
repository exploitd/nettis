require "crystagiri"

module Nettis
  class Scanner

    property :req
    property cookie= String.new # => Global cookie

    def initialize
      @ext_zone = Array(Int32).new
      @domains = Array(String).new
    end

    def get_whois(domain)
      c = Nettis::Http.whois(domain)
    end

    def get_domains
      c = Nettis::Http.domains
    end

  end
end
