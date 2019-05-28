5.times do

  Game.create(title: Faker::Game.title, genre: Faker::Game.genre, price: 60)
  Player.create(username: Faker::Internet.username, wallet: Faker::Number.number(3))
  Purchase.create(player_id: Player.all.sample.id, game_id: Game.all.sample.id)

end
