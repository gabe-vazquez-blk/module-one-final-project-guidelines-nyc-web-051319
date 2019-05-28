class Game < ActiveRecord::Base
  has_many :purchases
  has_many :players, through: :purchases

  def whos_playing
    self.players.map do |player|
      player.username
    end
  end

end
