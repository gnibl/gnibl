class Comment < ActiveRecord::Base
  attr_accessible :description, :gnib_id, :replyto_id, :user_id, :votes
  belongs_to :user
  
end
