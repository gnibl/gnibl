class Comment < ActiveRecord::Base
  attr_accessible :description, :gnib_id, :replyto_id, :user_id, :votes
  belongs_to :user

  def posted_date
    p "created at #{self.created_at}"
    p "now #{Time.now}"
    now = Time.now
    hours = ((now - self.created_at) / 1.hour).round
    p "hours #{hours}"
    if hours <= 0
      minutes = ((now - self.created_at) / 1.minute).round
      if minutes <= 0
        posted_date_str = "just a moment ago"
      else
        posted_date_str = "#{minutes} minutes ago"
      end
    elsif hours == 1
      posted_date_str = "an hour ago"
    elsif hours < 12
      posted_date_str = "#{hours} hours ago"
    else
      posted_date_str = self.created_at.to_formatted_s(:long_ordinal)
    end
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
