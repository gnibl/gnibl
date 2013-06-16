class Gnibling < ActiveRecord::Base
  attr_accessible :gnib_id, :user_id, :count
  belongs_to :user, :class_name => "User"
  belongs_to :gnib, :class_name => "Gnib"

  validates :gnib_id, :presence => true
  validates :user_id, :presence => true

end
