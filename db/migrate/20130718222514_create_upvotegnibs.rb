class CreateUpvotegnibs < ActiveRecord::Migration
  def change
    create_table :upvotegnibs do |t|
      t.integer :gnib_id
      t.integer :user_id

      t.timestamps
    end
  end
end
