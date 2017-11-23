require "crystagiri"

module Nettis
  module Scanner

    property :req

    # Get last 5 registered domains
    def self.find_(num)
      Nettis::Meta.p "Scanning for last #{num} domains registered on #{Nettis::Http::ENDPOINT}"

      doc = Crystagiri::HTML.from_url "#{Nettis::Http::ENDPOINT}"
      doc.where_class("right_text_normal_td").size
      #p doc
      doc.where_class("right_text_normal_td") do |tag|
        p tag.content
        p tag.node
      end
      #puts doc.where_class("right_text_normal_td") { |tag| puts tag.content}

      #@@req = Nettis::Http.call("/", "get")
      #p @@req
      #p @@req.body
      #p @@req
      #p @@req.call("/", "get")
      #@@req.call("/", "get")
    end

  end
end
