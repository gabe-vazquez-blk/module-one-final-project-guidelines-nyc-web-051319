class Game < ActiveRecord::Base
  has_many :purchases
  has_many :players, through: :purchases

  def whos_playing
    self.players.map do |player|
      player.username
    end
  end

  def self.all_by_title
    self.all.map do |game|
      game.title
    end
  end

  def select_game_by_title
    
  end

end
