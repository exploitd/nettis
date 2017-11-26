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

      doc = Crystagiri::HTML.new c
      doc.where_tag("img") do |tag|
        if tag.node.attributes[1].to_s.match(/whois.jpg/)
          whois = tag.node.attributes[0].content.to_s
          Nettis::Meta.p "Found whois for `#{domain}`: `#{whois}`."
        end
      end
    end

    def get_domains
      c = Nettis::Http.domains
    end

  end
end
