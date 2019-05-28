class CommandLineInterface

  def greet
    puts "Welcome to Game Shop!"
  end

  def create_player
    puts "What's your username?"
    username = gets.chomp
    puts "How much money would you like to put in your gaming wallet?"
    wallet = gets.chomp
    player = Player.create(username: username, wallet: wallet)
    puts "Welcome #{player.username}!"
  end

  def menu
    puts "What would you to do"
    puts "[1] View Games"
    puts "[2] Buy Game"
    puts "[3] Sell Game"
    option = gets.chomp
    case options
    when 1
      puts Game.all_by_title
    when 2
      puts "Which game would you like to buy?"
      puts Game.all_by_title

    when 3




end
