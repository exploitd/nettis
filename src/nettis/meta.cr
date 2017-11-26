module Nettis
  module Meta 

    ZONE_EXTENSION = {
      ".ba"     => 1,  # => Default
      ".org.ba" => 2,  # => Organizations
      ".net.ba" => 3,  # => Network
      ".gov.ba" => 4,  # => Government
      ".mil.ba" => 5,  # => Military (rare but exists)
      ".edu.ba" => 6,  # => Educational
    }

    def self.p(str)
      print "#{str}\n"
    end

    # Parse domain to type for NIC usage
    def self.parse_domain_to_whois(domain)
        
    end

  end
end
