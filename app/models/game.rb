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

  def self.all_by_title_puts
    self.all_by_title.each do |game|
      puts Rainbow("#{game}").blue
    end
  end

  def self.all_by_genre
    self.all.map do |game|
      game.genre
    end.uniq
  end

  def self.hash_of_genres
    arr = Game.all_by_genre
    arr.map {|genre| [arr.find_index(genre) + 1, genre] }.to_h
  end

  def self.puts_num_genre
    arr = Game.all_by_genre
    arr.each do |genre|
      puts Rainbow("[#{arr.find_index(genre) + 1}] #{genre}").blue
    end
  end

  def self.puts_title_with_index
    Game.all.each do |game|
      puts Rainbow("[#{game.id}] #{game.title}").blue
    end
  end

end
