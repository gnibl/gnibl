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
  attr_accessible :name,:surname, :city, :birthday, :email, 
                  :password,  :password_confirmation,:avatar, 
                  :username, :description, :validated, :validation_code,
                  :emailsecret, :secretcode
                  
  has_secure_password

  mount_uploader :avatar, AvatarUploader

  before_save do |user|
	require 'digest/md5'
    user.email = email.downcase
    user.username = user.email
    user.username = user.username.gsub(/(@.+)/, "")
    user.emailsecret =  Digest::MD5.hexdigest(user.email)
  end
  validates :birthday, :presence => true
  validates :name, :presence => true, :length => { :maximum => 80 }
  validates :surname, :presence => true, :length => { :maximum => 80 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true,
    :format =>     { :with => VALID_EMAIL_REGEX },
    :uniqueness => { :case_sensitive => false }

  validates :password, :presence => true, :length => {:minimum => 6}
  validates :password_confirmation, :presence => true
#  validates :city, :presence => true
# validates :validated, :presence => true
  validates :validation_code, :presence => true

  has_many :authorizations
  has_many :gnibs, :dependent => :destroy
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :followed_users, :through => :relationships, :source => :followed
  has_many :reverse_relationships, :foreign_key => "followed_id",
    :class_name => "Relationship",
    :dependent => :destroy
  has_many :followers, :through => :reverse_relationships , :source => :follower

  has_many :gniblings, :foreign_key => "user_id", :dependent => :destroy

  has_many :redefgnibs, :through => :gniblings, :source => :gnib

  belongs_to :city

  has_many :notifications, :foreign_key => "user_id", :dependent => :destroy, :order => 'updated_at DESC'
  has_many :notification_gnibs, :through => :notifications, :source => :gnib

  def redefined_mygnibs
    #my gnibs include all gnibs I gnibbed and also mine
    #select all gnibs where id is in select gnib_id from gniblings where user_id = me

  end

  def feed
    Gnib.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def like(gnib_id)
#   @existing_like = gniblings.where("gnib_id = ? and user_id = ?", gnib_id,)
    @liking = gniblings.find_by_gnib_id(gnib_id)
    if @liking
      @liking.update_attribute("count", @liking.count + 1)
    else
      gniblings.create(:gnib_id => gnib_id, :count => 1)
    end
  end

  def follow!(other_user)
    relationships.create!(:followed_id => other_user.id)
  end

  def unfollow(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  def self.create_from_hash!(hash,data)
    create(:name => data.name)
  end

  def html_safe_username
     #this method does nothing, remove it and all its occurences
     return self.username
  end

  def self.correct_username_from_safe_html_username(html_safe_username)
     #this method does nothing, remove it and all its occurences
     return html_safe_username
  end
end
