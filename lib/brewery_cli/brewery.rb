module BreweryCli
    class Brewery
        attr_accessor :name, :street, :city, :phone, :id
        attr_reader :state, :brewery_name, :brewery_type

        @@all = []
        @@cache = []
        
        def initialize(attributes={}) 
            attributes.each do |attribute, value| 
                if respond_to?("#{attribute}=")
                    self.send(("#{attribute}="), value)
                end
            end
            @@all << self
            @@cache << self
        end

        def state=(state)
            @state = State.find_or_create_by_name(state)
        end

        def brewery_type=(brewery_type)
            @brewery_type = BreweryType.find_or_create_by_name(brewery_type)
        end

        def self.all
            @@all
        end

        def self.cache
            @@cache
        end

        def self.clear
            all.clear
        end

        def self.load_by_zip(zip)
            self.clear
            API.get_breweries_by_zip(zip).collect do |brewery_info|
                self.new(brewery_info)
            end
            self.clean_up_breweries
        end

        def self.load_by_state(state)
            self.clear
            API.get_breweries_by_state(state).collect do |brewery_info|
                self.new(brewery_info)
            end
            self.clean_up_breweries
        end

        def self.load_by_city(city)
            self.clear
            API.get_breweries_by_city(city).collect do |brewery_info|
                self.new(brewery_info)
            end
            self.clean_up_breweries
        end

        def self.clean_up_breweries
            all.reject! { |brewery| brewery.name == nil || brewery.brewery_type == "planning"}
        end
    end
end