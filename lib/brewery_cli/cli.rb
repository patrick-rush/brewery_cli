# TODO
#     MAKE IT POSSIBLE TO SEARCH BY STATE
#     RETURN A MESSAGE SAYING WHERE THE USER IS SEARCHING
#     LOOK INTO FORMATTING IN THE TERMINAL

module BreweryCli
    class CLI

        @input = nil

        def start
            puts "\nWelcome to the Brewery Database CLI!"
            main_menu
            start_point
            credits
        end

        def start_point
            while input_not_exit
                get_user_input
                interpret_user_input_for_main_menu
            end
        end

        def main_menu
            puts <<-MENU
            
            Please enter the zip of the location you would like to search.
            Typing 'menu' at any time will return you to the main menu.
            Typing 'exit' at any time will end the program.
            MENU
        end

        def get_user_input
            @input = gets.chomp
        end

        def input_not_exit
            @input != "exit" && @input != "quit" && @input != "stop"
        end

        def interpret_user_input_for_main_menu
            while input_not_exit
                if @input == "menu"
                    main_menu
                    start_point
                elsif @input.length == 5 && @input.to_i != 0
                    print_breweries
                    brewery_menu
                    get_user_input
                    interpret_user_input_for_brewery_menu
                elsif input_not_exit #@input != "exit" && @input != "quit" && @input != "stop"
                    puts "Sorry, that was not a valid entry. Please try again."
                    get_user_input
                end
            end
        end

        def breweries
            Brewery.load(@input)
            Brewery.all.collect { |brewery| "#{brewery.name} - #{brewery.city}" }
        end

        def print_breweries
            breweries.each.with_index(1) { |brewery, i| puts "#{i}. #{brewery}"}
        end

        def brewery_menu
            puts <<-BREWERY_MENU

            Please choose a brewery by entering its number.
            Typing 'menu' at any time will return you to the main menu.
            Typing 'exit' at any time will end the program.
            BREWERY_MENU
        end

        def interpret_user_input_for_brewery_menu
            while input_not_exit
                if @input == "menu"
                    puts "\nPerhaps you'd like to search another location?"
                    main_menu
                    start_point
                elsif @input.to_i != 0 && @input.to_i.between?(0, Brewery.all.length)
                    index = @input.to_i - 1
                    print_brewery_info(index)
                    nested_menu
                    get_user_input
                    interpret_user_input_for_nested_menu
                elsif input_not_exit
                    puts "Sorry, that was not a valid entry. Please try again."
                    get_user_input
                end
            end
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

        def interpret_user_input_for_nested_menu
            while input_not_exit
                if @input == "menu"
                    puts "\nPerhaps you'd like to search another location?"
                    main_menu
                    start_point
                elsif @input.to_i != 0 && @input.to_i.between?(0, Brewery.all.length)
                    index = @input.to_i - 1
                    print_brewery_info(index)
                    nested_menu
                    get_user_input
                    interpret_user_input_for_nested_menu
                elsif input_not_exit
                    puts "Sorry, that was not a valid entry. Please try again."
                    get_user_input
                end
            end
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