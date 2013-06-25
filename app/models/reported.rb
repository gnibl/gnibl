class Reported < ActiveRecord::Base
  attr_accessible :gnib_id, :reporter_id, :status
  validate :gnib_id, :presence => true
  validate :reporter_id, :presence => true

   belongs_to :gnib, :class_name => "Gnib"
  
end
