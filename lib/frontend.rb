class Frontend
  def init (config)
    if config["ARRAY"].empty?
      puts "You have no chosen currencies at this time"
    else
      puts "The currencies you are following are: #{config["ARRAY"]}"
    end

    puts "\nWhat would you like to do?"
    puts "-- Type 'add' to add a currency."
    puts "-- Type 'remove' to remove a currency."
    puts "-- Type 'print' to print history of chosen values."
    puts "-- Type 'populate' to fill history with new info from the past 30 days (or less, if it hasn't been a month yet)"
    puts "-- Type 'ok' to continue."

    choice = gets.chomp

    case choice
    when 'add'
      while true

        puts "Choose which currencies to add. You are currentyly following: #{config["ARRAY"]}"
        puts "\nType currencies to follow: 'USD', 'EUR', 'GBP', 'AUD', or type 'EXIT' to finish and save"

        currency = gets.chomp.upcase

        break if currency == 'EXIT'

        if config["ARRAY"].include? currency
          puts "\nYou are already following that currency"
        else
          puts "You are now following #{currency}"
          config["ARRAY"] << currency
        end
      end
      File.open("data/config.yml", 'w') { |f| YAML.dump(config, f) }

    when 'remove'
      while true
        puts "Choose which currencies to remove. You are currentyly following: #{config["ARRAY"]}. Type 'EXIT' to finish and save."
        currency = gets.chomp.upcase

        break if currency == 'EXIT' || config["ARRAY"].empty?

        if config["ARRAY"].include? currency
          config["ARRAY"].delete(currency)
        else
          puts "Not a valid currency name. Choose another."
        end
      end
      File.open("data/config.yml", 'w') { |f| YAML.dump(config, f) }

    when 'print'
      History.new.print(config["ARRAY"])
      exit

    when 'populate'
      History.new.populate
      exit

    when 'ok'
      puts "No changes have been made."

    else abort("Sorry, didn't understand that. Exiting...")
    end
  end
end
