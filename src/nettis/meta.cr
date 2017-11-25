module Nettis
  module Meta 

    ZONE_EXTENSION = [
      ".ba",      # => Default
      ".org.ba",  # => Organizations
      ".net.ba",  # => Network
      ".gov.ba",  # => Government
      ".edu.ba",  # => Educational
      ".mil.ba",  # => Military (rare but exists, not visible in stats due to state protection)
    ]

    def self.p(str)
      print "#{str}\n"
    end

  end
end
