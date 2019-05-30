require 'pry'
class CommandLineInterface

  # def greet
  #   puts Rainbow("Welcome to Game Shop! 🎮").red.blink
  #   puts ""
  # end

  def greet
    mario
  end

  def mario
    Catpix::print_image "./lib/Mario2.png",
        :limit_x => 1,
        :limit_y => 1,
        :center_x => true,
        :center_y => true,
        :bg_fill => true,
        :resolution => "high"
  end

  def are_you_a_player
    puts Rainbow("Are you a returning player?(y/n)").skyblue
    answer = gets.chomp
    case answer
    when "y"
      puts "Welcome back!"
      returning_player
    when "n"
      create_account
    else
      "Invalid"
      are_you_a_player
    end
  end

  def create_account
    puts "Would you like to create an account?(y/n)"
    word = gets.chomp
    case word
    when "y"
      create_player
    when "n"
      closing_time
    else
      puts "Invalid"
      create_account
    end
  end

  def returning_player
    puts "What's your username"
    username = gets.chomp
    if Player.player_usernames.include?(username)
      user = Player.find_by(username: username)
      buy_or_sell(user)
    else
      couldnt_find_username
    end
  end

  def couldnt_find_username
    puts "Couldn't find username!"
    puts "[1] Try again"
    puts "[2] Create an account"
    puts "[3] EXIT"
    answer = gets.chomp
    case answer
    when "1"
      returning_player
    when "2"
      create_player
    when "3"
      closing_time
    else
      "Invalid Entry!"
      couldnt_find_username
    end
  end

  def create_player
    puts "What's your username?"
    username = gets.chomp
    player = Player.create(username: username, wallet: wallet=0)
    if player.valid?
      puts "How much money would you like to put in your gaming wallet?"
      money = gets.chomp
      player.update(wallet: money.to_i)
      puts "Welcome #{player.username} you have $#{player.wallet}!"
      buy_or_sell(player)
    else
      puts "Please select a different username."
      create_player
    end
  end

  def buy_or_sell(player)
    puts "Would you like to:"
    puts "[1] View Game Menu"
    puts "[2] My Wallet"
    puts "[3] Buy Games"
    puts "[4] Sell Games"
    puts "[5] Exit"
    answer = gets.chomp
    case answer
    when "1"
      view_games(player)
    when "2"
      my_wallet(player)
    when "3"
      buy_more_games(player)
    when "4"
      sell_my_games(player)
    when "5"
      closing_time
    when "hidden"
      puts Player.name_player
      buy_or_sell(player)
    else
      "Invalid"
      buy_or_sell(player)
    end
  end

  def view_games(player) #buy_or_sell menu [1]
    puts "What would you like to do"
    puts "[1] View All Games"
    puts "[2] View My Games"
    puts "[3] Exit"
    option = gets.chomp
    case option
    when "1"
      puts Game.all_by_title
      buy_or_sell(player)
    when "2"
      if player.my_games.count == 0
        puts "You have zero games."
      else
        puts player.my_games
      end
      buy_or_sell(player)
    when "3"
      closing_time
    else
      puts "Invalid"
    end
  end

  def view_wallet(player)
    puts "You have $#{player.wallet}."
    buy_or_sell(player)
  end

  def buy_more_games(player) #buy_or_sell [3]
    puts "What games would like to buy?"
    Game.puts_title_with_index
    puts "Select game by number"
    answer = gets.chomp
    game = Game.find_by(id: answer)
    if game
      player.buy_game(game)
      puts "You bought #{game.title}."
    else
      puts "Invalid Entry. Please try again..."
      buy_more_games(player)
    end
    buy_or_sell(player)
  end

  def sell_my_games(player) #buy_or_sell [4]
    if player.my_games.count > 0
      puts "Would you like to sell any of your games? (y/n)"
      puts player.my_games
      answer = gets.chomp
      case answer
      when "y"
        selling_games(player)
      when "n"
        puts "Returning to Menu..."
      else
        puts "Invalid Entry"
        sell_my_games(player)
      end
    else
      puts "You don't have any games to sell."
      puts "Returning to menu..."
    end
    buy_or_sell(player)
  end

  def selling_games(player)
    puts "What games would you like to sell for half price?"
    player.puts_my_game_id
    puts "Select game by number"
    answer = gets.chomp
    game = Game.find_by(id: answer)
    if game && player.my_games.include?(game.title)
      purchase = player.find_purchase(game)
      player.return_game(purchase)
      puts "You sold #{game.title}"
    else
      puts "Invalid Entry"
      selling_games(player)
    end
  end

  def add_to_wallet(player)
    puts "How much would you like to add?"
    money = player.wallet + gets.chomp.to_i
    player.update(wallet: money)
    puts "You have $#{player.wallet}."
    buy_or_sell(player)
  end

  def my_wallet(player) #buy_or_sell menu [2]
    puts "[1] View Wallet"
    puts "[2] Add to Wallet"
    puts "[3] Return to Menu"
    answer = gets.chomp

    case answer
    when "1"
      view_wallet(player)
    when "2"
      add_to_wallet(player)
    when "3"
      buy_or_sell(player)
    else
      puts "Invalid"
      my_wallet(player)
    end
  end

  def closing_time #buy_or_sell [5]
    puts "Thanks for stopping by"
  end
end
