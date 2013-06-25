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
  def parsed_description
    term = self.description[/#[\w\d]+\b/i]
    if term
      term = term[1..-1]
    end
    uid = self.description[/\@[\w\d]+\b/i]
    if uid
      uid = uid[1..-1]
    end
    puts "terms and uid #{term} #{uid}"
    parsed_description = self.description
    if(term)
      parsed_description = parsed_description.gsub(/#[\w\d]+\b/i, '<a href="/gnibs/search?term='+term+'" style="color: #17aeff">\0</a>')
    end
    if uid
      parsed_description = parsed_description.gsub(/\@[\w\d]+\b/i, '<a href="/users/search?uid='+uid+'" style="color: #17aeff">\0</a>')
    end
    puts "parsed_description #{parsed_description}"
    parsed_description.html_safe
  end
end
