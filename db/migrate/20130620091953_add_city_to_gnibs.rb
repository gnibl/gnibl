class AddCityToGnibs < ActiveRecord::Migration
  def change
    add_column :gnibs, :city, :integer
  end
end
