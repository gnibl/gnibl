class AddProfileSummaryToUsers < ActiveRecord::Migration
   def change
     add_column :users, :profile_summary, :string, :length => 77
   end
 end
