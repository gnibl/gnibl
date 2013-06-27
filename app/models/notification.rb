class Notification < ActiveRecord::Base
  attr_accessible :gnib_id, :message, :user_id
  belongs_to :user
  belongs_to :gnib
end
