module GniblUtil
  def inform_tagged_gniblers(gnib)
    comment = gnib.description
    send_notifications_ontags(gnib, gnib.user, comment)
  end


def send_notifications_on_comment(gnib_id, comment)
    @gnib = Gnib.find(gnib_id)
#    notify_gnib_commenters(gnib_id,comment)
#    send_notifications_ontags(@gnib,comment.user, comment.description)
    notify_gnibler(@gnib, comment)
end

def send_notifications_ontags(gnib,tagger, comment)
    count_email = 0
    count_tagged = 0
    tagged = []
    emails = []
    unless(comment.nil?)
      pos = -1
      len = comment.length
      while pos = comment.index('@',pos+1)
        tag = comment[pos+1..len].split(" ")[0]
        if (t = tag.index('@',0))
          emails[count_email] = tag
          count_email += 1
          pos = comment.index('@',pos+1)
        else
	        tagged[count_tagged] = tag
          count_tagged += 1
        end
      end
    end
    #find those in gnibl by username n send notifications
    while count_tagged > 0
      tag = tagged[count_tagged-1]
      send_notifications(gnib,tagger, tag)
      count_tagged -= 1
    end


    #find those tagged as email addresses n send email

    while count_email > 0
      email = emails[count_email-1]
      text = "welcome to gnibl fellow"
      invite_by_mail(gnib, email)
      count_email -= 1
    end


end


  def notify_gnibler(gnib, comment)
    user_id = gnib.user.id
    gnib_id = gnib.id
    nots = Notification.where("user_id = :user_id and gnib_id = :gnib_id", :user_id => user_id, :gnib_id => gnib_id)
    if nots.empty?
      message = "@"+comment.user.name+" commented on your gnib"
      Notification.create(:user_id => user_id, :gnib_id => gnib_id, :message => message)
    else
      user = "@"+comment.user.name
      msg = user +", "+nots[0].message
      nots[0].update_attribute("message",msg)
    end
  rescue Exception => e
    puts "Exception #{e}"
  end


def notify_gnib_commenters(gnib_id, comment_src)
@gnib = Gnib.find(gnib_id)
commenter = comment_src.user
commenter_name = commenter.name
follower_ids = commenter.followers.map(&:id)
comments = Comment.where({:gnib_id => gnib_id, :user_id => follower_ids})
comments.each do |comment|
past_commenter_id = comment.user_id
notify_past_commenter(past_commenter_id, gnib_id, commenter_name)
end
end

def notify_past_commenter(past_commenter_id, gnib_id, commenter_name)
nots = Notification.where("user_id = :user_id and gnib_id = :gnib_id", :user_id => past_commenter_id, :gnib_id => gnib_id)
    if nots.empty?
      message = "@"+commenter_name+" posted a comment "
      Notification.create(:user_id => past_commenter_id, :gnib_id => gnib_id, :message => message)
    else
      msg = "@"+commenter_name+" posted a comment " +", "+nots[0].message
      nots[0].update_attribute("message",msg)
    end
  rescue Exception => e
    puts "Exception #{e}"
end

  def send_notifications(gnib,from, to)
    sender = from
    target_users = sender.followers.where("name ilike :to or surname ilike :to or username ilike :to", :to => "%"+to+"%")
    gnib_id = gnib.id
    message = "@"+sender.name + " has tagged you "
    target_users.each do |target_user|
      user_id = target_user.id
      nots = Notification.where("user_id = :user_id and gnib_id = :gnib_id", :user_id => user_id, :gnib_id => gnib_id)
      if nots.empty?
        message = "@"+sender.name+" tagged you in a gnib"
        Notification.create(:user_id => target_user.id, :gnib_id => gnib.id, :message => message)
      end
    end
  end

  def invite_by_mail(gnib, email)
    @gnib =gnib
    m = UserMailer::invite_to_gnibl(@gnib,email)
    m.deliver
  end
end
