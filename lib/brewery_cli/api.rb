require 'open-uri'
require 'json'
require 'pry'

module BreweryCli
    class API
        def self.get_breweries_by_zip(zip)
            short_zip = zip[0...-2]
            json_string = open("https://api.openbrewerydb.org/breweries?by_postal=#{short_zip}&per_page=50").read
            JSON.parse(json_string)
        end
    end
end

# state.sub! " ", "_"
