class CreateAddSecretcodeToUsers < ActiveRecord::Migration
  def change
    create_table :add_secretcode_to_users do |t|
      t.string :secretcode

      t.timestamps
    end
  end
end
