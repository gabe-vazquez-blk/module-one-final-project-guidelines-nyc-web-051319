class Player < ActiveRecord::Base

  has_many :purchases
  has_many :games, through: :purchases

  def buy_game(game)
    if self.wallet >= game.price
      self.wallet -= game.price
      self.save
      Purchase.create(player_id: self.id, game_id: game.id)
      "You have purchsed #{game.title} for $#{game.price}!"
    else
      "Sorry not enough money!"
    end
  end


  def return_game(purchase)
    game = Game.find(purchase.game_id)
    self.wallet += game.price
    self.save
    purchase.destroy
  end

  def sell_game(buyer, game)
    selling_price = game.price * 0.8
    if selling_price <= buyer.wallet
      #excute purchase
      Purchase.create(player_id: buyer.id, game_id: game.id)
      #exchange money
      self.wallet += selling_price
      buyer.wallet -= selling_price
      #remove purchase from seller history
      self.games.destroy(game)
      self.save
      buyer.save
      "Pleasure doing business #{buyer.name}!"
    else
      "Necesitas mas dinero!"
    end
  end

  def my_games
    self.games.map do |game|
      game.title
    end
  end

end
