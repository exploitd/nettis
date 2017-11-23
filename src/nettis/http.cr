require "net/http"
require "uri"

module Http

  ENDPOINT = "http://nic.ba" #jfc they still on http!
  SSL = 0

  # Prepare endpoint with a gateway
  def call(uri)
    @uri = URI.parse(ep, met)
    @request = met.eq("post") ? Net::HTTP::Post.new(uri) : Net::HTTP::Get.new(uri)
  end

  # Execute endpoint with request data
  def execeute(request, uri)
    response = Net::HTTP.start(uri.hostname, uri.port, request_ops) do |http|
      http.request(req)
    end
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
    request["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36
    (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36"
    request["Accept"] = "*"
    request["Referer"] = "#{ENDPOINT}/lat/menu/view/13"
    request["Connection"] = "keep-alive"
  end

end
