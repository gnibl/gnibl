class AddValidationCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :validation_code, :string
  end
end
