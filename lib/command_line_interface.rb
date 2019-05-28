class CommandLineInterface

  def greet
    puts "Welcome to Game Shop"
  end

  def create_player
    puts "What's your username?"
    username = gets.chomp
    puts "How much money would you like to put in your gaming wallet?"
    wallet = gets.chomp
    player = Player.create(username: username, wallet: wallet)
    puts "Welcome #{player.username}!"
  end
end
