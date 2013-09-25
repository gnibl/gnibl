class AddSecretcodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :secretcode, :string
  end
end
