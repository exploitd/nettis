module Nettis

  # Module Meta instance of nettis. This module provides helper methods for
  # country-meta discovery. Part of the source is integration to whois platform.
  #
  # @author Halis Duraki <duraki@linuxmail.org>
  module Meta 

    # Possible top and sub TLD on country level zone. Domain to type.
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

    # Extract domain extension from given URL.
    # 
    # @param [String] domain URL domain
    # @return [String] domain extension
    def self.domain_ext(domain)
      ext = URI.parse(domain).to_s.split('.')

      ext.shift           # => remove domain name
      ".#{ext.join(".")}" # => return proper ".ext"
    end

    # Map domain to zone extension for NIC usage - [e] nic.ba => 1
    # 
    # @param [String] domain URL domain
    # @return [Integer] zone type
    def self.parse_domain_to_type(domain)
      ZONE_EXTENSION[self.domain_ext(domain)]
    end

  end
end
