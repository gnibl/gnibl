class Comment < ActiveRecord::Base
  attr_accessible :description, :gnib_id, :replyto_id, :user_id, :votes
  belongs_to :user

  def posted_date
    p "created at #{self.created_at}"
    p "now #{Time.now}"
    now = Time.now
    hours = ((now - self.created_at) / 720).round
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
end
