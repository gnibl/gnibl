class AddEmailsecretToUser < ActiveRecord::Migration
  def change
    add_column :users, :emailsecret, :string
  end
end
