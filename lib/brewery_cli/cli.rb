# TODO
#     MAKE IT POSSIBLE TO SEARCH BY STATE
#     RETURN A MESSAGE SAYING WHERE THE USER IS SEARCHING
#     DONE = LOOK INTO FORMATTING IN THE TERMINAL
#     FIX IT SO THAT YOU CAN'T TYPE A LETTER
#     DONE = MAKE SURE IF THERE ARE NO BREWERIES IN THAT ZIP, IT NOTIFIES YOU

module BreweryCli
    class CLI

        @input = nil
        # @breweries = []

        def get_user_input
            @input = gets.chomp
            if @input == "BACKDOOR"
                binding.pry 
            end
        end

        def input_not_exit
            @input != "exit" && @input != "quit" && @input != "stop" && @input != "end"
        end

        def valid_brewery?
            @input.to_i != 0 && @input.to_i.between?(0, Brewery.cache.length) || @input.to_i.between?(0, Brewery.all.length)
        end

        def valid_all?
            @input.to_i != 0 && @input.to_i.between?(0, Brewery.cache.length)
        end

        def breweries
            @breweries
        end

        def start
            puts "\nWelcome to the Brewery Database CLI!".colorize(:cyan)
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

        def main_menu_interpreter
            while input_not_exit
                if @input == "menu"
                    main_menu
                    start_point
                elsif @input == "all"
                    print_all
                    get_user_input
                elsif @input == "1"
                    search_by_zip_menu
                    get_user_input
                    search_by_zip_menu_interpreter
                elsif @input == "2"
                    search_by_city_menu
                    get_user_input
                    search_by_city_menu_interpreter
                elsif @input == "3"
                    search_by_state_menu
                    get_user_input
                    search_by_state_menu_interpreter
                elsif input_not_exit #@input != "exit" && @input != "quit" && @input != "stop"
                    puts "\nSorry, that was not a valid entry. Please try again.".colorize(:light_yellow)
                    get_user_input
                end
            end

        end

        def search_by_zip_menu_interpreter
            while input_not_exit
                if @input == "menu"
                    main_menu
                    start_point
                elsif @input == "all"
                    # RETURN ALL 
                elsif @input.length == 5 && @input.to_i != 0 #<= This needs to be refactored 
                    if get_breweries_by_zip.length == 0
                        puts "\nUh-oh! It looks like there are no entries for that location! \nTry entering a different zip.".colorize(:light_yellow)
                        get_user_input
                    else
                        print_breweries_by_zip
                        brewery_menu
                        get_user_input
                        brewery_menu_interpreter
                    end
                elsif input_not_exit #@input != "exit" && @input != "quit" && @input != "stop"
                    puts "\nSorry, that was not a valid entry. Please try again.".colorize(:light_yellow)
                    get_user_input
                end
            end
        end

        def search_by_city_menu_interpreter
            while input_not_exit
                if @input == "menu"
                    main_menu
                    start_point
                elsif @input == "all"
                    # RETURN ALL
                elsif get_breweries_by_city.length == 0
                    puts "\nUh-oh! It looks like there are no entries for that location! \nTry entering a different city.".colorize(:light_yellow)
                    get_user_input
                else
                    print_breweries_by_city
                    brewery_menu
                    get_user_input
                    brewery_menu_interpreter
                # elsif input_not_exit #@input != "exit" && @input != "quit" && @input != "stop"
                #     puts "\nSorry, that was not a valid entry. Please try again.".colorize(:light_yellow)
                #     get_user_input
                end
            end
        end

        def search_by_state_menu_interpreter
            while input_not_exit
                if @input == "menu"
                    main_menu
                    start_point
                elsif @input == "all"
                    # RETURN ALL
                elsif get_breweries_by_state.length == 0
                    puts "\nUh-oh! It looks like there are no entries for that location! \nTry entering a different state.".colorize(:light_yellow)
                    get_user_input
                else
                    print_breweries_by_state
                    brewery_menu
                    get_user_input
                    brewery_menu_interpreter
                # elsif input_not_exit #@input != "exit" && @input != "quit" && @input != "stop"
                #     puts "\nSorry, that was not a valid entry. Please try again.".colorize(:light_yellow)
                #     get_user_input
                end
            end
        end

        def brewery_menu_interpreter
            while input_not_exit
                if @input == "menu"
                    puts "\nPerhaps you'd like to search another location?".colorize(:cyan)
                    main_menu
                    start_point
                elsif @input == "all"
                    # RETURN ALL 
                elsif valid_brewery?
                    retrieve_brewery
                elsif @input.length == 5 && @input.to_i != 0
                    puts "It looks like you entered a zip! Would you like to try searching another locations? \nPlease enter Y/N".colorize(:cyan)
                    get_user_input
                    if @input == "Y" || @input == "y" || @input == "yes"
                        puts "Please enter the zip of the location you would like to search."
                        get_user_input
                        search_by_zip_menu_interpreter
                    elsif @input == "N" || @input == "n" || @input == "no"
                        puts "Okay. You can see another brewery by entering its number now."
                        get_user_input
                        brewery_menu_interpreter
                    end
                elsif input_not_exit
                    puts "\nSorry, that was not a valid entry. Please try again.".colorize(:light_yellow)
                    get_user_input
                end
            end
        end

        def get_breweries_by_zip
            Brewery.load_by_zip(@input)
            breweries = Brewery.all.collect { |brewery| "#{brewery.name} - #{brewery.city}" }
        end

        def print_breweries_by_zip
            get_breweries_by_zip.each.with_index(1) { |brewery, i| puts "#{i}. #{brewery}"}
        end

        def get_breweries_by_state
            Brewery.load_by_state(@input)
            breweries = Brewery.all.collect { |brewery| "#{brewery.name} - #{brewery.city}" }
        end

        def print_breweries_by_state
            get_breweries_by_state.each.with_index(1) { |brewery, i| puts "#{i}. #{brewery}"}
        end

        def get_breweries_by_city
            Brewery.load_by_city(@input)
            breweries = Brewery.all.collect { |brewery| "#{brewery.name} - #{brewery.city}" }
        end

        def print_breweries_by_city
            get_breweries_by_city.each.with_index(1) { |brewery, i| puts "#{i}. #{brewery}"}
        end

        def retrieve_brewery
            index = @input.to_i - 1
            print_brewery_info(index)
            nested_menu
            get_user_input
            brewery_menu_interpreter
        end

        def print_all
            Brewery.cache.each.with_index(1) { |brewery, i| puts "#{i}. #{brewery.name} (#{brewery.state.name})" }
        end
                
        def main_menu
            puts <<-NEW_MAIN

            There are three ways you can search the Brewery Database!
            
            1. By zip code
            2. By city name
            3. By state name

            Please enter the number for how you would like to search. 

            Typing 'all' at any time will return a list of all the breweries you have seen so far. 
            Typing 'menu' at any time will return you to the main menu.
            Typing 'exit' at any time will end the program.
            NEW_MAIN
        end

        def search_by_zip_menu
            puts <<-MENU
            
            Please enter the zip of the location you would like to search.
            Typing 'menu' at any time will return you to the main menu.
            Typing 'exit' at any time will end the program.
            MENU
        end

        def search_by_city_menu
            puts <<-MENU
            
            Please enter the name of the city you would like to search (do not include the state).
            Typing 'menu' at any time will return you to the main menu.
            Typing 'exit' at any time will end the program.
            MENU
        end

        def search_by_state_menu
            puts <<-MENU
            
            Please enter the name of the state you would like to search.
            Typing 'menu' at any time will return you to the main menu.
            Typing 'exit' at any time will end the program.
            MENU
        end

        def print_brewery_info(index)
            brewery = Brewery.all[index]
            puts <<-INFO
            --------------------
            Name: #{brewery.name.colorize(:cyan)}
            Location: #{brewery.street.colorize(:cyan)}, #{brewery.city.colorize(:cyan)}, #{brewery.state.name.colorize(:cyan)}
            Phone: (#{brewery.phone[0..2].colorize(:cyan)}) #{brewery.phone[3..5].colorize(:cyan)}-#{brewery.phone[6..9].colorize(:cyan)}
            --------------------
            INFO
        end

        def brewery_menu
            puts <<-BREWERY_MENU

            Please choose a brewery by entering its number.
            Typing 'menu' at any time will return you to the main menu.
            Typing 'exit' at any time will end the program.
            BREWERY_MENU
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