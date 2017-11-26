require "http/client"
require "uri"
require "crest"

module Nettis
  module Http

    ENDPOINT = "http://nic.ba" # => jfc they still on http!
    SSL = 0

    property uri
    property response

    def self.util
      "curl"
    end

    def self.headers(ref, cookie)
      "-H 'Cookie: PHPSESSID=#{cookie}; language=lat' -H 'Origin: #{ENDPOINT}' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-GB,en;q=0.9,en-US;q=0.8,bs;q=0.7,hr;q=0.6,de;q=0.5' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Referer: #{ref}' -H 'Connection: keep-alive' -H 'DNT: 1'"  
    end

    def self.parse_domain(domain)

    end

    def self.curl_whois(domain, type, token, cookie)
      # => xxx: parse domain here
      
      api = "#{ENDPOINT}/lat/menu/view/13"
      cmd = "#{self.util} '#{api}' #{self.headers(api, cookie)} --data 'whois_input=#{token}&whois_select_name=#{domain}&whois_select_type=#{type}&submit=Poka%C5%BEi+WHOIS+podatke&submit_check=on' --compressed"  

      self.run(cmd)
    end

    def self.run(cmd)
      o = IO::Memory.new
      Process.run(cmd, shell: true, output: o) 
      o.close
      o.to_s
      #exit
    end

    # Prepare endpoint with a gateway
    def self.call(uri, met)
      url = URI.parse("#{ENDPOINT}/#{uri}")
      @@response = met.compare("post") ? HTTP::Client.new(ENDPOINT).post(uri) : HTTP::Client.new(ENDPOINT).get(uri)
    end

    def set_ct(request, ct)
      request.content_type = ct
    end

    # Set form data where data is arr
    # data = [ "key" => "value" ]
    def set_from(request, data)
      request.set_form_data(data) 
    end

    def set_private(request)
      request["Origin"] = ENDPOINT
      request["Upgrade-Insecure-Requests"] = "1"
      request["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36"
      request["Accept"] = "*"
      request["Referer"] = "#{ENDPOINT}/lat/menu/view/13"
      request["Connection"] = "keep-alive"
    end

 end
end
