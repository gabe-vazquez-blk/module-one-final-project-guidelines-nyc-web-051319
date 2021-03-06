class Player < ActiveRecord::Base

  has_many :purchases
  has_many :games, through: :purchases

  validates :username, uniqueness: true
  # validates_numericality_of :wallet, :greater_than_or_equal_to => 0

  def buy_game(game)
    if self.wallet >= game.price
      money = self.wallet - game.price
      self.update(wallet: money)
      self.reload
      Purchase.create(player_id: self.id, game_id: game.id)
      puts Rainbow("You have purchsed #{game.title} for $#{game.price}!").pink
    else
      puts Rainbow("Sorry, not enough money!").pink
    end
  end

  def select_game_by_title(game_title)
    Game.find_by(title: game_title)
  end

  def return_game(purchase)
    game = Game.find(purchase.game_id)
    money = self.wallet + (game.price / 2)
    self.update(wallet: money)
    purchase.destroy
    self.reload
  end

  def self.name_player
    self.all.map do |player|
      player.username
    end
  end

  def self.puts_name_player
    self.name_player.each do |player|
      puts Rainbow("#{player}").pink
    end
  end
  #
  # def sell_game(buyer, game)
  #   selling_price = game.price * 0.8
  #   if selling_price <= buyer.wallet
  #     #excute purchase
  #     Purchase.create(player_id: buyer.id, game_id: game.id)
  #     #exchange money
  #     self.wallet += selling_price
  #     buyer.wallet -= selling_price
  #     #remove purchase from seller history
  #     self.games.destroy(game)
  #     self.save
  #     buyer.save
  #     "Pleasure doing business #{buyer.name}!"
  #   else
  #     "Necesitas mas dinero!"
  #   end
  # end

  def my_games
    self.games.map do |game|
      game.title
    end
  end

  def puts_my_games
    count = 1
    self.my_games.each do |game|
      puts Rainbow("#{count}. #{game}").blue
      count += 1
    end
  end

  def self.player_usernames
    self.all.map do |player|
      player.username
    end
  end

  def puts_my_game_id
    self.games.each do |game|
      puts Rainbow("[#{game.id}] #{game.title}").blue
    end
  end

  def find_purchase(game)
    self.purchases.find do |purchase|
      purchase.game_id == game.id
    end
  end
end
