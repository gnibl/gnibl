class AddBirthdayToUsers < ActiveRecord::Migration
  def change
    add_column :gnibs, :imageurl, :string
    add_column :gnibs, :link, :string
  end
end
