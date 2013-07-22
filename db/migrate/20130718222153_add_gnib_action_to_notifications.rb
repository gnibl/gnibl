class AddGnibActionToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :gnib_action, :integer
  end
end
