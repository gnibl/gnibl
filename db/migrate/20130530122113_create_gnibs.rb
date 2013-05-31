class CreateGnibs < ActiveRecord::Migration
  def change
    create_table :gnibs do |t|
      t.integer :user_id
      t.string :title
      t.string :landmark
      t.string :description
      t.integer :visibility
      t.string :image

      t.timestamps
    end
    add_index :gnibs, [:user_id, :created_at]
  end
end
