class Upvotegnib < ActiveRecord::Base
  attr_accessible :gnib_id, :user_id
  belongs_to :gnib
end
