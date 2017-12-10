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

    property domains   =Array(String).new
   
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
    def parse_zone_status(body)
      puts body.at_class("right_text_nromal_td")

      content.each_line.with_index do |l, i|
        @tld << l.gsub(/[^\d]/, "").to_i32 if i == 4  # => .ba
        @tld << l.gsub(/[^\d]/, "").to_i32 if i == 12 # => .org.ba
        @tld << l.gsub(/[^\d]/, "").to_i32 if i == 20 # => .net.ba
        @tld << l.gsub(/[^\d]/, "").to_i32 if i == 28 # => .gov.ba
        @tld << l.gsub(/[^\d]/, "").to_i32 if i == 36 # => .edu.ba
      end

      Nettis::Meta.p "Status: BA - #{@ext_zone[0]} # ORG.BA #{@ext_zone[1]} # NET.BA #{@ext_zone[2]} # GOV.BA #{@ext_zone[3]} # EDU.BA #{@ext_zone[4]}"
    end

    def first_sidebar_oc(body)
      body.where_class("right_text_normal_td") { |t| return t }
      raise HtmlException.new(tag="right_text_normal_td")
    end

    def sidebar_oc(body : Crystagiri::HTML, index)
      i = 0
      body.where_class("right_text_normal_td") do |tag|
        return tag if i == index
        i += 1
      end 
      raise HtmlException.new(tag="right_text_normal_td")
    end

    def parse_new_domains(body)
      tag = first_sidebar_oc(body)
      t = sidebar_oc(body, 11)

      t.node.text.each_line.with_index do |l, i|
        if i == 1 && !l.strip.empty?
          l.strip.split(".ba").each.with_index do |domain, j|
            next if j == 5 # => probably a bug (aka no domain found)

            Nettis::Meta.p "Found latest registered domain: #{domain}.ba"
            @domains << "#{domain}.ba"
          end
        end
      end
    end

  end

end
end
