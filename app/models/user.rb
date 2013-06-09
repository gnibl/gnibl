# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :city, :avatar, :username, :description
 
  has_secure_password
  
  mount_uploader :avatar, AvatarUploader
 
 before_save do |user| 
	user.email = email.downcase 
        user.username = user.email
	user.username = user.username.gsub(/(@.+)/, "")
 end

  validates :name, :presence => true, :length => { :maximum => 80 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true,
                    :format =>     { :with => VALID_EMAIL_REGEX },
                    :uniqueness => { :case_sensitive => false }

  validates :password, :presence => true, :length => {:minimum => 6}
  validates :password_confirmation, :presence => true
 

  has_many :authorizations
  has_many :gnibs, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                    class_name: "Relationship",
                                    dependent: :destroy
  has_many :followers, through: :reverse_relationships , source: :follower

def feed
    Gnib.from_users_followed_by(self)
end

def following?(other_user)
   relationships.find_by_followed_id(other_user.id)
end

def follow!(other_user)
relationships.create!(followed_id: other_user.id)
end

def unfollow(other_user)
relationships.find_by_followed_id(other_user.id).destroy
end

def self.create_from_hash!(hash,data)
create(:name => data.name)
end
end
