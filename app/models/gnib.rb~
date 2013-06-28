class Gnib < ActiveRecord::Base
  attr_accessible :description, :image, :landmark, :title, :visibility, :city
  belongs_to :user
  validates :user_id, :presence => true
  validates :description, :presence => true, :length => { :maximum => 77}

  default_scope :order => 'gnibs.created_at DESC'

  mount_uploader :image, GnibUploader
  has_many :gniblings, :foreign_key => "gnib_id"
  has_many :reporteds, :foreign_key => "gnib_id"
  has_many :notifications, :foreign_key => "gnib_id"

  def self.from_users_followed_by(user)
    ids = "SELECT followed_id from relationships WHERE follower_id = :user_id"
    where("user_id IN (#{ids}) OR user_id = :user_id",:user_id => user)
  end

  def parsed_description
comment = self.description
final_comment = ""
len = comment.length

lastpos = 0
pos = -1
while (pos = comment.index('#',pos+1))
 tag =  comment[pos+1 ..len].split(" ")[0]
 replacement_string = "<a style='color: #17aeff' href = '/gnibs/search?term="+tag+"'>"+tag+"</a>"
 final_comment += comment[lastpos..pos] + replacement_string
lastpos = pos +1+tag.length
if t = tag.index('@',0) # cater for @address@gmail.com
pos = comment.index('@',pos+1)
end
end

pos = -1
lastpos = 0
while (pos = comment.index('@',pos+1))
 tag =  comment[pos+1 ..len].split(" ")[0]
 replacement_string = "<a style='color: #17aeff' href = '/users/search?uid="+tag+"'>"+tag+"</a>"
 final_comment += comment[lastpos..pos] + replacement_string
lastpos = pos +1+tag.length
if t = tag.index('@',0) # cater for @address@gmail.com
pos = comment.index('@',pos+1)
end
end
 return final_comment.html_safe

  end
end
