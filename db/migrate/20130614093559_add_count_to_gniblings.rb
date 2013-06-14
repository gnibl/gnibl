class AddCountToGniblings < ActiveRecord::Migration
  def change
    add_column :gniblings, :count, :integer
  end
end
