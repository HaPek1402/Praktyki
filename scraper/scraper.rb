require "httparty" 
require "nokogiri"
require "open-uri"

module Scraper
    def self.included(base)
        base.class_eval do
            def initialize(url)
                response = HTTParty.get( url, { 
                    headers: { 
                        "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36" 
                    }, 
                })
                @document = Nokogiri::HTML(response.body)
            end
        end
      end
end