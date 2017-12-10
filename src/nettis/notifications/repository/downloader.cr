require "http/client"

module Nettis

  class Downloader 

    DEFAULT_WHOIS_IMG = "WHOISED.png"

    def initialize(url : String, out : String)
      @url = url
      @out = out
    end

    def download

      client = HTTP::Client.get @url
      if client.status_code == 200

        path = URI.parse(@url).path.to_s
        fn = DEFAULT_WHOIS_IMG # File.basename(path) # => Default name from URL

        Dir.mkdir(@out) if !Dir.exists?(@out)

          File.open(File.join(@out, fn), "wb") do |file|
            file.puts client.body
            puts "#{client.status_message}: #{@url}"
          end

      else
        puts "#{client.status_message}: #{@url}"
      end

    end

  end

end
