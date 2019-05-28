class CreateGames < ActiveRecord::Migration[4.2]
  def change
    create_table :games do |t|
      t.string :title
      t.string :genre
      t.integer :price
    end
  end
end
