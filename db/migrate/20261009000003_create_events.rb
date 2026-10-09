class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.references :listing, null: false, foreign_key: true
      t.string :kind, null: false
      t.timestamps
    end
    add_index :events, [:listing_id, :kind]
  end
end
