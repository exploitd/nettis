module Nettis

  # Main object to source NIC. This is official origin of country Bosnia and
  # Herzegovina. The `nic` was born at `UTIC` (that is - [Univerzitetski
  # tele-informatički centar]) and is official registrator of domain.
  # @see [https://en.wikipedia.org/wiki/.ba]
  #
  # @attr [String] cookie cookie token[s]
  # @attr [String] t session token[s]
  # @attr [Array] ext_zone a list of extensions mapped to ary 
  # @attr [Array] domains list of string of domain names
  # @attr [Nic::Parser] parser extraction used for this service
  class Nic

    # Supposed service ID.
    SOURCE_NAME = "NIC"

    # Supposed service endpoint.
    ENDPOINT    = "http://nic.ba" # => jfc they still on http!

    # Supposed service SSL trigger.
    SSL         = 0

    property cookie = String.new # => Cookie
    property t      = String.new # => Token

    property ext_zone = Array(Int32).new
    property domains  = Array(String).new

    # => Object[s] init
    property parser   = Nic::Parser.new

    def initialize
      Nettis::Meta.p "Initializing a new service with name: [#{SOURCE_NAME}] ..."
      token
    end

    # Extract x-site protection code for reuse on given source.
    #
    # This is same code that is bundled within domain origin as a CSRF
    # protection. By filling the list of reusable codes, we will execute whois
    # request attached with this data.
    #
    # Also extract cookie since `PHPSESSID` is directly used with token. Later
    # on we reuse both of this values to get whois data.
    #
    # @return [String]
    def token
      client = HTTP::Client.get URI.parse(ENDPOINT + "/lat/menu/view/13")
      @cookie = parser.parse_session(client)

      doc = Crystagiri::HTML.new client.body
      @t = parser.parse_token(doc)
    
      Nettis::Meta.p "Found available token for use with hash [#{@t}] and cookie `#{@cookie}`! Go go."
      @t
    end

    # Set cookie in use. Some client requests requires token + session match
    # so this method should prepare that.
    #
    # @param [Net::HTTP.Client] client request client
    def set_cookie(client)
      client.before_request do |req|
        req.cookies << HTTP::Cookie.new("PHPSESSID", @cookie)
      end
    end

    # Execute a whois on the current source. Requires a domain on which the
    # whois shall be done.
    #
    # @param [String] domain URL domain
    # @return [Object] whois info 
    def whois(domain)
      Nettis::Meta.p "Doing a whois on a URL #{domain} with info given on #{ENDPOINT}"

      client = HTTP::Client.new URI.parse(ENDPOINT)
      set_cookie(client)

      # => Whois request to get a generated image
      c = client.post_form "/lat/menu/view/13", 
        "whois_input=#{@t}&\
         whois_select_name=#{parser.parse_domain_without_tld(domain)}&\
         whois_select_type=#{parser.domain_to_type(domain)}&\
         submit=1&\
         submit_check=on" 

      doc = Crystagiri::HTML.new c.body
      img = parser.parse_whois_image(doc)
    
      Nettis::Meta.p "Found whois image: [#{img}] :)`."
    
      # xxx: Save image and process to ocr
      Nettis::Downloader.new(img.to_s, "/tmp/").download
    end

    # Extract last five registered domains on project source. On `nic` it is
    # bundled-on at the frontend.
    # 
    # @return [Hash]
    def last_five
      Nettis::Meta.p "Scanning for last domains registered on #{ENDPOINT}"

      doc = Crystagiri::HTML.from_url "#{ENDPOINT}"
      domains = parser.parse_new_domains(doc)
    end

    # Extract status or zone statistics based on `nic/utic` margins.
    # 
    # @return [Hash]
    def status
      Nettis::Meta.p "Scanning for last domain status on #{ENDPOINT}"

      doc = Crystagiri::HTML.from_url "#{ENDPOINT}"
      tld = parser.parse_zone_status(doc)
    end
    
  end
end
