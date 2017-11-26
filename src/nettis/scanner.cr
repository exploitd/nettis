require "crystagiri"

module Nettis
  class Scanner

    property :req
    property cookie= String.new #= String.new

    def initialize
      @ext_zone = Array(Int32).new
      @domains = Array(String).new
    end

    # Extract x-site protection code for reuse
    #
    # This is same code that is bundled within domain origin as a CSRF
    # protection. By filling the list of reusable codes, we will execute whois
    # request attached with this data.
    #
    # Also extract cookie since `PHPSESSID` is directly used with token. Later
    # on we reuse both of this values to get whois data.
    #
    # xxx: extract token from [current] whois (if exists)
    #      , as seen previously there is another input on each completed whois
    def token
      client = HTTP::Client.new URI.parse(Nettis::Http::ENDPOINT)
      c = client.get "/lat/menu/view/13" # => tokens are on whois page
    
      self.cookie = c.cookies["PHPSESSID"].value.to_s # => Extract cookie from same req

      doc = Crystagiri::HTML.new c.body

      doc.where_tag("input") do |tag|
        return tag.node.attributes["value"].text # => Always [1st] input tag consists of token
      end
    end

    def whois_(domain)
      whois(domain)
    end

    def whois(domain)
      Nettis::Meta.p "Doing a whois on domain: #{domain} [using: #{Nettis::Http::ENDPOINT}] ..."

      t = token
      Nettis::Meta.p "Found available token for use with hash [#{t}] and cookie `#{@cookie}`! Go go."

      doc = Nettis::Http.curl_whois(domain, 1, t, @cookie)
      p doc
    end

    def last_domains(content)
      Nettis::Meta.p "Extracting last registered domains .."

      content.each_line.with_index do |l, i|
        if i == 1 && !l.strip.empty? 
          l.strip.split(".ba").each.with_index do |domain, j|
            next if j == 5 # => probably a bug (aka no domain found)
            Nettis::Meta.p "Found latest registered domain: #{domain}.ba"
            @domains << "#{domain}.ba"
          end
        end
      end
    end

    def zone_status(content)
      Nettis::Meta.p "Extracting status for zone extension .."

      content.each_line.with_index do |l, i|
        @ext_zone << l.gsub(/[^\d]/, "").to_i32 if i == 4  # => .ba
        @ext_zone << l.gsub(/[^\d]/, "").to_i32 if i == 12 # => .org.ba
        @ext_zone << l.gsub(/[^\d]/, "").to_i32 if i == 20 # => .net.ba
        @ext_zone << l.gsub(/[^\d]/, "").to_i32 if i == 28 # => .gov.ba
        @ext_zone << l.gsub(/[^\d]/, "").to_i32 if i == 36 # => .edu.ba
      end

      Nettis::Meta.p "Status: BA - #{@ext_zone[0]} # ORG.BA #{@ext_zone[1]} # NET.BA #{@ext_zone[2]} # GOV.BA #{@ext_zone[3]} # EDU.BA #{@ext_zone[4]}"

      # {@ext_zone[0]}" => O(n)[.ba]
    end

    # Get last 5 registered domains
    def find_(num)
      Nettis::Meta.p "Scanning for last #{num} domains registered on #{Nettis::Http::ENDPOINT}"

      doc = Crystagiri::HTML.from_url "#{Nettis::Http::ENDPOINT}"
      doc.where_class("right_text_normal_td") do |tag|
        self.zone_status(tag.content) if tag.content.match(/BA domena/)
        self.last_domains(tag.content) if tag.content.match(/.ba/)
      end
    end

  end
end
