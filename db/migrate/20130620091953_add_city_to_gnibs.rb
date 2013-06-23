class AddCityToGnibs < ActiveRecord::Migration
  def change
    remove_column :gnibs, :city
    add_column :gnibs, :city, :string
  end
end
