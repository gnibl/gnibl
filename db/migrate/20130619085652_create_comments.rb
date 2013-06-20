class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :gnib_id
      t.integer :replyto_id
      t.string :description
      t.integer :votes

      t.timestamps
    end
  end
end
