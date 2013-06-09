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
  has_many :gnibs, :dependent => :destroy


def self.create_from_hash!(hash,data)
  create(:name => data.name)
end
end
