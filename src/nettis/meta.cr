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

    def self.domain_ext(domain)
      ext = URI.parse(domain).to_s.split('.')
      ext.shift           # => remove domain name
      ".#{ext.join(".")}" # => return proper ".ext"
    end

    # Map domain to zone extension for NIC usage
    # e.g. nic.ba => 1
    def self.parse_domain_to_type(domain)
      ZONE_EXTENSION[self.domain_ext(domain)]
    end

  end
end
