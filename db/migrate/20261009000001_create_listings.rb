class CreateListings < ActiveRecord::Migration[8.1]
  def change
    create_table :listings do |t|
      t.string :title, null: false
      t.text :description
      t.integer :starting_price, null: false
      t.datetime :ends_at, null: false
      t.timestamps
    end
  end
end
