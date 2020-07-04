module BreweryCli
    class BreweryType

        attr_accessor :name
        @@all = []

        def initialize(name)
            @name = name
            @@all << self
        end

        def breweries
            Brewery.all.select { |brewery| brewery.brewery_type == self}
        end

        def self.all
            @@all
        end

        def self.find_or_create_by_name(name)
            self.all.find { |brewery_type| brewery_type.name == name} || self.new(name)
        end

    end
end