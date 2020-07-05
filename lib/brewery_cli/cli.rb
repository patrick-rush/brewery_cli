module BreweryCli
    class CLI

        @input = nil
        @switch = nil

        def start
            puts "\nWelcome to the Brewery Database CLI!"
            main_menu
            start_point
            credits
        end

        def start_point
            while input_not_exit
                get_user_input
                main_menu_interpreter
            end
        end

        def get_user_input
            @input = gets.chomp
            if @input == "BACKDOOR"
                binding.pry 
            end
        end

        def input_not_exit
            @input != "exit" && @input != "quit" && @input != "stop" && @input != "end"
        end

        def go_home
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
            puts "\nSorry, that was not a valid entry. Please try again."
            get_user_input
        end

        def main_menu_interpreter
            while input_not_exit
                if go_home
                    main_menu
                    start_point
                elsif @input == "1"
                    @switch = 1
                    search_menu
                    get_user_input
                    search_menu_interpreter
                elsif @input == "2"
                    @switch = 2
                    search_menu
                    get_user_input
                    search_menu_interpreter
                elsif @input == "3"
                    @switch = 3
                    search_menu
                    get_user_input
                    search_menu_interpreter 
                elsif input_not_exit
                    invalid_entry
                end
            end
        end

        def search_menu_interpreter 
            while input_not_exit
                if go_home
                    main_menu
                    start_point
                elsif get_breweries.length == 0
                    puts "\nUh-oh! It looks like there are no entries for that location! \nTry entering a different state."
                    get_user_input
                else
                    print_breweries
                    brewery_menu
                    get_user_input
                    brewery_menu_interpreter
                end
            end
        end

        def brewery_menu_interpreter
            while input_not_exit
                if go_home
                    puts "\nPerhaps you'd like to search another location?"
                    main_menu
                    start_point
                elsif valid_brewery?
                    @switch = 4
                    retrieve_brewery
                elsif valid_zip?
                    puts "It looks like you entered a zip! Would you like to try searching another locations? \nPlease enter Y/N"
                    get_user_input
                    if @input == "Y" || @input == "y" || @input == "yes"
                        puts "Please enter the zip of the location you would like to search."
                        get_user_input
                        search_menu_interpreter
                    elsif @input == "N" || @input == "n" || @input == "no"
                        puts "Okay. You can see another brewery by entering its number now."
                        get_user_input
                        brewery_menu_interpreter
                    end
                elsif input_not_exit
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
                    get_breweries
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
            get_breweries.each.with_index(1) { |brewery, i| puts "#{i}. #{brewery}"}
        end

        def retrieve_brewery
            index = @input.to_i - 1
            print_brewery_info(index)
            nested_menu
            get_user_input
            brewery_menu_interpreter
        end

        def main_menu
            puts <<-NEW_MAIN

            There are three ways you can search the Brewery Database!
            
            1. By zip code
            2. By city name
            3. By state name

            Please enter the number for how you would like to search. 

            Typing 'menu' at any time will return you to the main menu.
            Typing 'exit' at any time will end the program.
            NEW_MAIN
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
            puts <<-MENU
            
            Please enter the #{x} of the #{y} you would like to search#{z}. 
            Typing 'menu' at any time will return you to the main menu.
            Typing 'exit' at any time will end the program.
            MENU
        end

        def brewery_menu
            puts <<-BREWERY_MENU

            Please choose a brewery by entering its number.

            Typing 'menu' at any time will return you to the main menu.
            Typing 'exit' at any time will end the program.
            BREWERY_MENU
        end

        def print_brewery_info(index)
            brewery = Brewery.all[index]
            puts <<-INFO

            --------------------
            Name: #{brewery.name}
            Location: #{brewery.street}, #{brewery.city}, #{brewery.state}
            Phone: (#{brewery.phone[0..2]}) #{brewery.phone[3..5]}-#{brewery.phone[6..9]}
            --------------------
            INFO
        end

        def nested_menu
            puts <<-NESTED_MENU

            You can see another brewery by entering its number now.
            or
            Typing 'menu' at any time will return you to the main menu.
            Typing 'exit' at any time will end the program.
            NESTED_MENU
        end

        def credits
            puts <<-CREDITS
            --------------------
            Thank you for using the Brewery Database CLI!
            This program was built by Patrick Rush for Flatiron School (2020).
            This program uses the Open Brewery Database API which can be found at:
                https://www.openbrewerydb.org/
            Cheers!
            --------------------
            CREDITS
        end

    end
end