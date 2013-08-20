class Gnib < ActiveRecord::Base
  attr_accessible :description, :image, :landmark, :title, :visibility, :city, :imageurl, :link, :video
  belongs_to :user
  validates :user_id, :presence => true
  validates :description, :presence => true, :length => { :maximum => 77}

  default_scope :order => 'gnibs.created_at DESC'

  mount_uploader :image, GnibUploader
  has_many :gniblings, :foreign_key => "gnib_id"
  has_many :reporteds, :foreign_key => "gnib_id"
  has_many :notifications, :foreign_key => "gnib_id"
  has_many :upvotegnibs, :foreign_key => "gnib_id"

 def regnibbedby(current_user)
 #return a string indicating the first names of those
 # who have regnibbed this gnib 
 # who also happen to followed by current user
message = ""

#check if current_user has regnibbed
me_regnibbed = regnibbers =  self.gniblings.select('user_id').where('user_id = '+current_user.id)
unless me_regnibbed.empty?
message = "you "
end

regnibbers =  self.gniblings.select('user_id')
regnibbers_friends = current_user.followed_users.where(:id => regnibbers).select('name')
gniblings_count = self.gniblings.count

if regnibbers_friends && regnibbers_friends.length > 0
     regnibbers_friends.each do | friend |
          message = message + friend.name + " "
     end
   end
return message
 end

def regnibbedby_div(current_user)
#return raw html describing the div to display
regnib_count = self.gniblings.count
div = "<div id='gnib_count_<%=gnib.id%>' style='border-bottom: 2px solid white; padding: 5px; text-align: left' align='center'> #{regnib_count} regnibs </div>"

regnibbers = regnibbedby(current_user)
div_friends = "<div id='gnib_count_<%=gnib.id%>' style=' padding: 5px; text-align: left' align='center'>regnibbed by <span style = 'color: #17ffae;'>  #{regnibbers[0..10]} </span> and #{regnib_count - 1} people</div>"

  if regnibbers && regnibbers.length > 1
      return div_friends 
  else
       return div
  end   
end

def upvotedby(current_user)
upvoters = self.upvotegnibs.select('user_id')
upvoters_friends = current_user.followed_users.where(:id => upvoters).select('name')

message = "up it"
  if upvoters_friends && upvoters_friends.length > 0
   message = "upped by "
     upvoters_friends.each do | friend |
          message = message + friend.name + " "
     end
   end
return message
end

  def self.from_users_followed_by(user)
    ids = "SELECT followed_id from relationships WHERE follower_id = :user_id"
    #both my gnibs and those am following
    #  where("user_id IN (#{ids}) OR user_id = :user_id",:user_id => user)
    where("user_id IN (#{ids})",:user_id => user)
  end

  def youtube_embeddable_url
    video_id = (/([\w-]{11})/.match(link)).to_s
    return "http://www.youtube.com/embed/"+video_id
  end

  def short_title
    limit = 30
    stitle = ''
    if title && title.size > limit
      stitle = title[0..limit]
    else
      stitle = title
    end
    return stitle
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
      if t = tag.index('#',0) # cater for @address@gmail.com
        pos = comment.index('#',pos+1)
      end
    end
    if  lastpos < len
      final_comment += comment[lastpos..len]
    end
    comment = final_comment
    final_comment = ""
    len = comment.length
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
    if lastpos < len
      final_comment += comment[lastpos..len]
    end

    unless pos = comment.index('@',0) #if there is no @tag
      final_comment = comment
    end

    return final_comment.html_safe
  end
end
