module BreweryCli
    class State

        attr_accessor :name
        @@all = []

        def initialize(name)
            @name = name
            @@all << self
        end

        def breweries
            Brewery.all.select { |brewery| brewery.state == self}
        end

        def self.all
            @@all
        end

        def self.find_or_create_by_name(name)
            self.all.find { |state| state.name == name} || self.new(name)
        end

    end
end