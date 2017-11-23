require "http/client"
require "uri"

module Nettis
  module Http

    ENDPOINT = "http://nic.ba" #jfc they still on http!
    SSL = 0

    property uri
    property response

    # Prepare endpoint with a gateway
    def self.call(uri, met)
      uri = URI.parse("#{ENDPOINT}/#{uri}")
      @@response = met.compare("post", true) ? HTTP::Client.post(uri) : HTTP::Client.get(uri)
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
