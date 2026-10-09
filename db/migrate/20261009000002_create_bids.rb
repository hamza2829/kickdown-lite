class CreateBids < ActiveRecord::Migration[8.1]
  def change
    create_table :bids do |t|
      t.references :listing, null: false, foreign_key: true
      t.string :bidder_name, null: false
      t.integer :amount, null: false
      t.timestamps
    end
  end
end
