class Notification < ActiveRecord::Base
  attr_accessible :gnib_id, :message, :user_id
end
