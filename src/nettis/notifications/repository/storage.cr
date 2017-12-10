require "csv"

module Nettis
  
  # Storage instance of nettis. This module is used to maintain data and
  # transactions that happened in `nettis`.
  # 
  # @author Halis Duraki <duraki@linuxmail.org>
  class Storage

    def self.csv(hash, filename)
      result = CSV.build do |csv|
        csv.row hash
      end

      puts result
    end

  end


end
