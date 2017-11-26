module Nettis
  class Nic

    SOURCE_NAME = "NIC"

    ENDPOINT  = "http://nic.ba" # => jfc they still on http!
    SSL       = 0

    # Request headers
    property cookie = String.new # => Cookie
    property t      = String.new # => Token

    # Domain status
    property ext_zone = Array(Int32).new
    property domains  = Array(String).new

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
      client = HTTP::Client.get URI.parse(ENDPOINT + "/lat/menu/view/13")
      @cookie = client.cookies["PHPSESSID"].value.to_s # => Extract cookie from same req

      doc = Crystagiri::HTML.new client.body

      doc.where_tag("input") do |tag|
        @t = tag.node.attributes["value"].text
        Nettis::Meta.p "Found available token for use with hash [#{@t}] and cookie `#{@cookie}`! Go go."
        return tag.node.attributes["value"].text
      end
    end

    def initialize
      Nettis::Meta.p "Initializing a new service with name: [#{SOURCE_NAME}] ..."
      token
    end

    def whois(domain)
      type = Nettis::Meta.parse_domain_to_type(domain)
      domain = domain.split(".")[0]

      client = HTTP::Client.new URI.parse(ENDPOINT)
      client.before_request do |req|
        req.cookies << HTTP::Cookie.new("PHPSESSID", @cookie)
      end

      c = client.post_form "/lat/menu/view/13", "whois_input=#{@t}&whois_select_name=#{domain}&whois_select_type=#{type}&submit=1&submit_check=on" 

      c.body # => html
    end

    def last_five
      Nettis::Meta.p "Scanning for last domains registered on #{ENDPOINT}"

      doc = Crystagiri::HTML.from_url "#{ENDPOINT}"
      doc.where_class("right_text_normal_td") do |tag|
        self.zone_status(tag.content) if tag.content.match(/BA domena/)
        self.last_domains(tag.content) if tag.content.match(/.ba/)
      end
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
    end

  end
end
