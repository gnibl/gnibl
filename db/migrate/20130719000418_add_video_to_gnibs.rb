class AddVideoToGnibs < ActiveRecord::Migration
  def change
    add_column :gnibs, :video, :boolean
  end
end
