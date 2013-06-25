class Gnib < ActiveRecord::Base
  attr_accessible :description, :image, :landmark, :title, :visibility, :city
  belongs_to :user
  validates :user_id, :presence => true
  validates :description, :presence => true, :length => { :maximum => 77}

  default_scope :order => 'gnibs.created_at DESC'

  mount_uploader :image, GnibUploader
  has_many :gniblings, :foreign_key => "gnib_id"
  has_many :reporteds, :foreign_key => "gnib_id"

  def self.from_users_followed_by(user)
   ids = "SELECT followed_id from relationships WHERE follower_id = :user_id"
   where("user_id IN (#{ids}) OR user_id = :user_id",:user_id => user)
  end

end
