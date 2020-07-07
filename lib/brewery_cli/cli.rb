module BreweryCli
    class CLI

        @input = nil
        @switch = nil
        @pride = nil

        def call 
            color("\nWelcome to the Brewery Database CLI!")
            start
            credits
        end

        def start
            while input_not_exit?
                main_menu
                get_user_input
                main_menu_interpreter
            end
        end

        def get_user_input
            @input = gets.chomp.downcase
            if @input == "backdoor"
                binding.pry 
            end
            if @input == "pride mode"
                @pride = 1
                color("\nWelcome to Pride Mode!")
                start
            end

        end

        def input_not_exit?
            @input != "exit" && @input != "quit" && @input != "stop" && @input != "end"
        end

        def go_home?
            @input == "menu" || @input == "home" || @input == "back"
        end 

        def valid_zip?
            int = @input.to_i
            int != 0 && int.to_s.length == 5
        end

        def valid_brewery?
            @input.to_i != 0 && @input.to_i.between?(0, Brewery.all.length) 
        end

        def invalid_entry
            puts ""
            color("Sorry, that was not a valid entry. Please try again.")
            puts ""
            color("Typing 'menu' at any time will return you to the main menu.")
            color("Typing 'exit' at any time will end the program.")
            puts ""
            get_user_input
        end

        def main_menu_interpreter
            while input_not_exit?
                if go_home?
                    start
                elsif @input == "1" || @input == "2" || @input == "3"
                    @switch = @input.to_i
                    search_menu 
                    get_user_input
                    search_menu_interpreter
                elsif input_not_exit?
                    invalid_entry
                end
            end
        end

        def search_menu_interpreter 
            while input_not_exit?
                if go_home?
                    start
                elsif get_breweries.respond_to?("length") && get_breweries.length == 0
                    color("\nUh-oh! It looks like there are no entries for that location! \nTry entering a different location.")
                    get_user_input
                elsif input_not_exit? && get_breweries.respond_to?("length") && get_breweries.length > 0
                    if @switch == 3
                        color("\nYou are viewing breweries in #{Brewery.all.first.state}.")
                        puts ""
                    else
                        color("\nYou are viewing breweries in and around #{Brewery.all.first.city}, #{Brewery.all.first.state}.")
                        puts ""
                    end
                    print_breweries
                    brewery_menu
                    get_user_input
                    brewery_menu_interpreter
                end
            end
        end

        def brewery_menu_interpreter
            while input_not_exit?
                if go_home?
                    color("\nPerhaps you'd like to search another location?")
                    start
                elsif valid_brewery?
                    retrieve_brewery
                elsif input_not_exit?
                    invalid_entry
                end
            end
        end

        def get_breweries 
            if @switch == 1
                if valid_zip?
                    Brewery.load_by_zip(@input)
                    Brewery.all.collect { |brewery| "#{brewery.name} - #{brewery.city}" }
                else
                    invalid_entry
                    search_menu_interpreter
                end
            elsif @switch == 2
                Brewery.load_by_city(@input)
                Brewery.all.collect { |brewery| "#{brewery.name} - #{brewery.city}" }
            elsif @switch == 3
                Brewery.load_by_state(@input)
                Brewery.all.collect { |brewery| "#{brewery.name} - #{brewery.city}" }
            end    
        end

        def print_breweries 
            get_breweries.each.with_index(1) { |brewery, i| color("#{i}. #{brewery}")}
        end

        def retrieve_brewery
            index = @input.to_i - 1
            print_brewery_info(index)
            nested_menu
            get_user_input
            brewery_menu_interpreter
        end

        def main_menu
            puts ""
            color("There are three ways you can search the Brewery Database!")
            puts ""
            color("1. By zip code")
            color("2. By city name")
            color("3. By state name")
            puts ""
            color("Please enter the number for how you would like to search.")
            puts ""
            color("Typing 'menu' at any time will return you here.")
            color("Typing 'exit' at any time will end the program.")
            puts ""
        end

        def search_menu
            if @switch == 1
                x = "zip"
                y = "location"
            elsif @switch == 2
                x = "name"
                y = "city"
                z = " (do not include the state)"
            elsif @switch == 3
                x = "name"
                y = "state"
            end
            puts ""
            color("Please enter the #{x} of the #{y} you would like to search#{z}.")
            puts ""
            color("Typing 'menu' at any time will return you to the main menu.")
            color("Typing 'exit' at any time will end the program.")
            puts ""
        end

        def brewery_menu
            puts ""
            color("Please choose a brewery by entering its number.")
            puts ""
            color("Typing 'menu' at any time will return you to the main menu.")
            color("Typing 'exit' at any time will end the program.")
            puts ""
        end

        def print_brewery_info(index)
            brewery = Brewery.all[index]
            puts ""
            color("--------------------")
            color("Name: #{brewery.name}")
            color("Location: #{brewery.street}, #{brewery.city}, #{brewery.state}")
            color("Phone: (#{brewery.phone[0..2]}) #{brewery.phone[3..5]}-#{brewery.phone[6..9]}")
            color("Website: #{brewery.website_url}")
            color("--------------------")
        end

        def nested_menu
            puts ""
            color("You can see another brewery by entering its number now.")
            color("or")
            color("Typing 'menu' at any time will return you to the main menu.")
            color("Typing 'exit' at any time will end the program.")
            puts ""
        end

        def credits
            puts ""
            color("--------------------")
            color("Thank you for using the Brewery Database CLI!")
            color("This program was built by Patrick Rush for Flatiron School (2020).")
            color("This program uses the Open Brewery Database API which can be found at:")
            color("  https://www.openbrewerydb.org/")
            color("Cheers!")
            color("--------------------")
            puts ""
        end

        def color(string)
            if @pride == nil
                puts "#{string}"
            else
                if @pride == 13
                    @pride = 1
                end
                if @pride == 1 || @pride == 2
                    puts "#{string}".colorize(:light_red)
                elsif @pride == 3 || @pride == 4
                    puts "#{string}".colorize(:light_yellow)
                elsif @pride == 5 || @pride == 6
                    puts "#{string}".colorize(:light_green)
                elsif @pride == 7 || @pride == 8
                    puts "#{string}".colorize(:light_cyan)
                elsif @pride == 9 || @pride == 10
                    puts "#{string}".colorize(:light_blue)
                elsif @pride == 11 || @pride == 12
                    puts "#{string}".colorize(:light_magenta)
                end
                @pride += 1
            end
        end

    end
end