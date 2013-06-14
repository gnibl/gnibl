class CreateGniblings < ActiveRecord::Migration
  def change
    create_table :gniblings do |t|
      t.integer :user_id
      t.integer :gnib_id

      t.timestamps
    end
  end
end
