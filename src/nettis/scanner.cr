require "crystagiri"

module Nettis
  class Scanner

    property :req

    def initialize
      @ext_zone = Array(Int32).new
      @domains = Array(String).new
    end

    def last_domains(content)
      Nettis::Meta.p "Extracting last registered domains .."

      content.each_line.with_index do |l, i|
        if i == 1 && !l.strip.empty? 
          l.strip.split(".ba").each.with_index do |domain, j|
            next if j == 5 # => probably a bug (aka no domain found)
            Nettis::Meta.p "Found domain: #{domain}.ba"
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
