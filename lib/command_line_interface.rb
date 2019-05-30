require 'pry'
class CommandLineInterface

  def greet
    pid = fork{ exec "afplay","lib/1 HOUR Super Mario Bros Theme Song.mp3"}
    welcome = Artii::Base.new :font => 'slant'
    puts Rainbow(welcome.asciify('WELOME TO')).red.blink
    puts Rainbow(welcome.asciify('GAME SHOP!')).red.blink
    puts ""
    sleep 1.0
  end

  def are_you_a_player
    puts Rainbow("Are you a returning player?(y/n)").skyblue
    answer = gets.chomp
    case answer
    when "y"
      new_menu
      puts Rainbow("Welcome back!").green
      returning_player
    when "n"
      new_menu
      create_account
    when "hidden"
      Player.puts_name_player
      are_you_a_player
    else
      new_menu
      puts Rainbow("Invalid Entry!").plum
      puts ""
      are_you_a_player
    end
  end

  def create_account
    puts Rainbow("Would you like to create an account?(y/n)").skyblue
    word = gets.chomp
    case word
    when "y"
      create_player
    when "n"
      closing_time
    else
      puts Rainbow("Invalid Entry!").plum
      create_account
    end
  end

  def returning_player
    puts Rainbow("What's your username?").skyblue
    username = gets.chomp
    if Player.player_usernames.include?(username)
      user = Player.find_by(username: username)
      new_menu
      buy_or_sell(user)
    else
      couldnt_find_username
    end
  end

  def couldnt_find_username
    new_menu
    puts Rainbow("Couldn't find username!").skyblue
    puts Rainbow("[1] Try again").silver
    puts Rainbow("[2] Create an account").silver
    puts Rainbow("[3] EXIT").silver
    answer = gets.chomp
    case answer
    when "1"
      new_menu
      returning_player
    when "2"
      new_menu
      create_player
    when "3"
      closing_time
    when "hidden"
      Player.puts_name_player
      are_you_a_player
    else
      puts Rainbow("Invalid Entry!").plum
      couldnt_find_username
    end
  end

  def create_player
    puts Rainbow("What username would you like?").skyblue
    username = gets.chomp
    player = Player.create(username: username, wallet: wallet=0)
    if player.valid?
      postive_money(player)
    else
      puts "Please select a different username."
      create_player
    end
  end

  def postive_money(player)
    puts Rainbow("How much money would you like to put in your gaming wallet?").skyblue
    money = gets.chomp
    money = money.to_i
    if money.positive? && money <=100000
      player.update(wallet: money)
      puts Rainbow("Welcome #{player.username} you have $#{player.wallet}!").yellow
      buy_or_sell(player)
    else
      puts "Please type in an integer between 0 and 100,000."
      postive_money(player)
    end
  end

  def buy_or_sell(player)
    puts Rainbow("Would you like to:").skyblue
    puts Rainbow("[1] View Game Menu").silver
    puts Rainbow("[2] My Wallet").silver
    puts Rainbow("[3] Buy Games").silver
    puts Rainbow("[4] Sell Games").silver
    puts Rainbow("[5] Exit").silver
    answer = gets.chomp
    case answer
    when "1"
      new_menu
      view_games(player)
    when "2"
      new_menu
      my_wallet(player)
    when "3"
      new_menu
      buy_more_games(player)
    when "4"
      new_menu
      sell_my_games(player)
    when "5"
      closing_time
    else
      puts Rainbow("Invalid Entry!").plum
      buy_or_sell(player)
    end
  end

  def view_games(player) #buy_or_sell menu [1]
    puts Rainbow("What would you like to do?").skyblue
    puts Rainbow("[1] View All Games").silver
    puts Rainbow("[2] View My Games").silver
    puts Rainbow("[3] Exit").silver
    option = gets.chomp
    case option
    when "1"
      new_menu
      Game.all_by_title_puts
      puts ""
      buy_or_sell(player)
    when "2"
      new_menu
      if player.my_games.count == 0
        puts Rainbow("You have zero games.").yellow
        puts ""
      else
        player.puts_my_games
        puts ""
      end
      buy_or_sell(player)
    when "3"
      closing_time
    else
      puts Rainbow("Invalid Entry!").plum
      view_games(player)
    end
  end

  def view_wallet(player)
    puts "You have $#{player.wallet}."
    buy_or_sell(player)
  end

  def buy_more_games(player) #buy_or_sell [3]
    puts Rainbow("What games would you like to buy?").skyblue
    puts ""
    puts Rainbow("All games are $60.").pink.blink
    puts ""
    Game.puts_title_with_index
    puts ""
    puts Rainbow("Select game by number").yellow
    answer = gets.chomp
    if answer == "exit"
      new_menu
      buy_or_sell(player)
    else
      game = Game.find_by(id: answer)
      if game
        player.buy_game(game)
      else
        puts Rainbow("Invalid Entry. Please try again...").plum
        buy_more_games(player)
      end
    end
      buy_or_sell(player)
  end

  def sell_my_games(player) #buy_or_sell [4]
    if player.my_games.count > 0
      puts Rainbow("Would you like to sell any of your games? (y/n)").skyblue
      player.puts_my_games
      answer = gets.chomp
      case answer
      when "y"
        selling_games(player)
      when "n"
        puts Rainbow("Returning to Menu...").white.blink
      when "exit"
        new_menu
        buy_or_sell(player)
      else
        puts Rainbow("Invalid Entry!").plum
        sell_my_games(player)
      end
    else
      puts Rainbow("You don't have any games to sell.").red
      puts Rainbow("Returning to menu...").white.blink
    end
    buy_or_sell(player)
  end

  def selling_games(player)
    puts Rainbow("What games would you like to sell for half price?").skyblue
    player.puts_my_game_id
    puts Rainbow("Select game by number").white
    answer = gets.chomp
    if answer == "exit"
      new_menu
      buy_or_sell(player)
    else
      game = Game.find_by(id: answer)
      if game && player.my_games.include?(game.title)
        purchase = player.find_purchase(game)
        player.return_game(purchase)
        puts Rainbow("You sold #{game.title}.").blue
        puts Rainbow("You now have $#{player.wallet} in your wallet").yellow
      else
        puts Rainbow("Invalid Entry!").plum
        selling_games(player)
      end
    end
  end

  def add_to_wallet(player)
    puts Rainbow("How much money would you like to add to your wallet?").skyblue
    amount = gets.chomp.to_i
    if amount == "exit"
      player.update(wallet: 0)
      new_menu
      buy_or_sell(player)
    else
      if amount.positive? && amount <= 100000
        money = player.wallet + amount
        player.update(wallet: money)
        puts Rainbow("You have $#{player.wallet}.").yellow
      else
        puts Rainbow("Please type in an integer between 0 and 100,000.").red
        add_to_wallet(player)
      end
    end
    buy_or_sell(player)
  end

  def my_wallet(player) #buy_or_sell menu [2]
    new_menu
    puts Rainbow("My Wallet:").skyblue
    puts Rainbow("[1] View Wallet").silver
    puts Rainbow("[2] Add to Wallet").silver
    puts Rainbow("[3] Return to Menu").silver
    answer = gets.chomp

    case answer
    when "1"
      new_menu
      view_wallet(player)
    when "2"
      new_menu
      add_to_wallet(player)
    when "3"
      new_menu
      buy_or_sell(player)
    else
      puts Rainbow("Invalid Entry!").plum
      my_wallet(player)
    end
  end

  def closing_time #buy_or_sell [5]
    system "clear"
    farewell = Artii::Base.new :font => 'slant'
    puts Rainbow(farewell.asciify('Thanks for stopping by!!!')).goldenrod.blink
    pid = fork{ exec "killall", "afplay" }
    exit
  end

  def new_menu
    system "clear"
    welcome = Artii::Base.new :font => 'slant'
    puts Rainbow(welcome.asciify('GAME SHOP!')).red.blink
    puts ""
    sleep 0.3
  end
end
