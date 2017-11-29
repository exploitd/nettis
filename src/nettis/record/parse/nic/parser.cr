module Nettis
class Nic

  class Parser

    PHPSESSID_TRY = "0x000000000000000000000000000000000"
    RIMG_NAME     = "WHOIS.JPG"

    property cookie=String.new
    property phpsessid=String.new
   
    def parse_session(client)
      client.cookies["PHPSESSID"].value.to_s 
    end

    def parse_token(body)
      body.where_tag("input") do |tag|
        return tag.node.attributes["value"].text
      end
      PHPSESSID_TRY
    end

    def domain_to_type(domain)
      Nettis::Meta.parse_domain_to_type(domain)
    end

    def parse_domain_without_tld(domain)
      domain.split(".")[0]
    end

    def parse_whois_image(body)
      body.where_tag("img") do |tag|

        if tag.node.attributes[1].to_s.upcase.match(/#{RIMG_NAME.upcase}/)
        Nettis::Meta.p "Found whois image: [#{tag.node.attributes[0].content.to_s}]`."
        return tag.node.attributes[0].content.to_s
      end

      end
    end

    def parse_zone_status(body)
      puts body.at_class("right_text_nromal_td")

      content.each_line.with_index do |l, i|
        @tld << l.gsub(/[^\d]/, "").to_i32 if i == 4  # => .ba
        @tld << l.gsub(/[^\d]/, "").to_i32 if i == 12 # => .org.ba
        @tld << l.gsub(/[^\d]/, "").to_i32 if i == 20 # => .net.ba
        @tld << l.gsub(/[^\d]/, "").to_i32 if i == 28 # => .gov.ba
        @tld << l.gsub(/[^\d]/, "").to_i32 if i == 36 # => .edu.ba
      end
    end

      #doc.where_class("right_text_normal_td") do |tag|
        #self.zone_status(tag.content) if tag.content.match(/BA domena/)
        #self.last_domains(tag.content) if tag.content.match(/.ba/)
      #end

    def first_sidebar_oc(body)
      body.where_class("right_text_normal_td") { |t| return t }
      raise HtmlException.new(tag="right_text_normal_td")
    end

    def sidebar_oc(body, index)
      body.where_class("right_text_normal_td").each do |tag|
        p i 
      end #{ |t| return t[index] }
      raise HtmlException.new(tag="right_text_normal_td")
    end

    def parse_new_domains(body)
      tag = first_sidebar_oc(body)
      t = sidebar_oc(body, 1)
      p tag.node
      p t
      #p tag.node
      #tag.node.each_line.with_index do |l, i|
        #if i == 1 && !l.strip.empty? 
          #l.strip.split(".ba").each.with_index do |domain, j|
            #next if j == 5 # => probably a bug (aka no domain found)
            #Nettis::Meta.p "Found latest registered domain: #{domain}.ba"
            #@domains << "#{domain}.ba"
          #end
        #end
      #end
    end

  end

end
end
