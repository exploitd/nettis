module Nettis


class Nic

  # Submodule of object source NIC for parsing metadata or given output. A
  # parser should do anything to extract `smart` source.
  #
  # @attr [String] cookie parse cookie
  # @attr [String] phpsessid parse session
  class Parser

    # An object of ph.
    PHPSESSID_TRY = "0x000000000000000000000000000000000"

    # An object of ph.
    RIMG_NAME     = "WHOIS.JPG"

    property cookie    =String.new
    property phpsessid =String.new

    property domains =Array(String).new
    property tld     =Array(Int32).new
   
    # Extract cookie.
    def parse_session(client)
      client.cookies["PHPSESSID"].value.to_s 
    end

    # Extract token.
    def parse_token(body)
      body.where_tag("input") do |tag|
        return tag.node.attributes["value"].text
      end
      PHPSESSID_TRY
    end

    # Extract domain to type.
    def domain_to_type(domain)
      Nettis::Meta.parse_domain_to_type(domain)
    end

    # Extract domain without extension.
    def parse_domain_without_tld(domain)
      domain.split(".")[0]
    end

    # Extract whois image from the body.
    def parse_whois_image(body)
      body.where_tag("img") do |tag|

        if tag.node.attributes[1].to_s.upcase.match(/#{RIMG_NAME.upcase}/)
        return tag.node.attributes[0].content.to_s
      end

      end
    end

    # Extract last domain pool size.
    #
    # @param [Crystagiri::HTML] body
    def parse_zone_status(body)
      @tld << sidebar_oc(body, 1).content.gsub(/[^\d]/, "").to_i32 # => .ba
      @tld << sidebar_oc(body, 3).content.gsub(/[^\d]/, "").to_i32 # => .org.ba
      @tld << sidebar_oc(body, 5).content.gsub(/[^\d]/, "").to_i32 # => .net.ba
      @tld << sidebar_oc(body, 7).content.gsub(/[^\d]/, "").to_i32 # => .gov.ba
      @tld << sidebar_oc(body, 9).content.gsub(/[^\d]/, "").to_i32 # => .edu.ba

      Nettis::Meta.p "Got status! Hol'on ..."

      t = TerminalTable.new
      t.headings = ["Zone         ", "Total domains"]
      t << [Nettis::Meta::ZONE_EXTENSION.key(1), @tld[0]]
      t << [Nettis::Meta::ZONE_EXTENSION.key(2), @tld[1]]
      t << [Nettis::Meta::ZONE_EXTENSION.key(3), @tld[2]]
      t << [Nettis::Meta::ZONE_EXTENSION.key(4), @tld[3]]
      t << [Nettis::Meta::ZONE_EXTENSION.key(6), @tld[4]]

      puts t.render

      @tld
    end

    # Get first sidebar occurence
    # 
    # @param [Crystagiri::HTML] body
    # @return [Crystagiri::Tag]
    def first_sidebar_oc(body)
      body.where_class("right_text_normal_td") { |t| return t }
      raise HtmlException.new(tag="right_text_normal_td")
    end

    # Get sidebar occurence by index id
    # 
    # @param [Crystagiri::HTML] body
    # @param [Int] index
    # @return [Crystagiri::Tag]
    def sidebar_oc(body : Crystagiri::HTML, index)
      i = 0
      body.where_class("right_text_normal_td") do |tag|
        return tag if i == index
        i += 1
      end 
      raise HtmlException.new(tag="right_text_normal_td")
    end

    # Extract new or latest domains from this source
    #
    # @param [Crystagiri::HTML] body
    # @return [Array] domains
    def parse_new_domains(body)
      tag = first_sidebar_oc(body)
      t = sidebar_oc(body, 11)

      t.node.text.each_line.with_index do |l, i|
        if i == 1 && !l.strip.empty?
          l.strip.split(".ba").each.with_index do |domain, j|
            return if j > 4 # => Extract up to 5 domains

            Nettis::Meta.p "Found latest registered domain: #{domain}.ba"
            @domains << "#{domain}.ba"
          end
        end
      end

      @domains
    end

  end

end
end
