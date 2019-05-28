class CreatePurchases < ActiveRecord::Migration[4.2]
  def change
    create_table :purchases do |t|
      t.integer :player_id
      t.integer :game_id
    end
  end
end
