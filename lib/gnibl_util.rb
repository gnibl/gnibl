module GniblUtil
  # definitions GNIB_ACTION_COMMENT = 1, GNIB_ACTION_UPVOTE = 2, GNIB_ACTION_TAGGED = 3 REGNIB = 4 FOLLOWED = 5 UPCOMMENT = 6

  def send_notifications_on_create(gnib)
    comment = gnib.description
    send_notifications_ontags(gnib, gnib.user, comment)
  end

  def send_notifications_on_being_gnibbled(user,follower)
    gnib_action_upvote = 5
    user_id = gnib.user.id
    gnib_id = gnib.
    nots = Notification.where("user_id = :user_id and gnib_id = :gnib_id and gnib_action = :gnib_action", :user_id => user_id, :gnib_id => gnib_id, :gnib_action =>gnib_action_upvote)
    if nots.empty?
      message = follower.name+" is gnibbling you"
      Notification.create(:user_id => user_id, :gnib_id => gnib_id, :gnib_action =>gnib_action_upvote, :read => false, :message => message)
    else
      prev_notification = nots[0]
      prev_upvoter_name = prev_notification.message.split(" ")[0]
      message = regnibber.name + "is gnibbling you"
      prev_notification.update_attribute("message",message)
      prev_notification.update_attribute("read",false)
    end
  end

  def send_notifications_on_upvote_comment(gnib,upvoter)
	if upvoter.id == gnib.user.id
	return
	end
    gnib_action_upvote = 6
    user_id = gnib.user.id
    gnib_id = gnib.id
    nots = Notification.where("user_id = :user_id and gnib_id = :gnib_id and gnib_action = :gnib_action", :user_id => user_id, :gnib_id => gnib_id, :gnib_action =>gnib_action_upvote)
    if nots.empty?
      message = upvoter.name+" has upvoted a comment"
      Notification.create(:user_id => user_id, :gnib_id => gnib_id, :gnib_action =>gnib_action_upvote, :read => false, :message => message)
    else
      prev_notification = nots[0]
      if prev_notification.read?
          message = upvoter.name + " has upvoted a comment"
      else
          prev_upvoter_name = prev_notification.message.split(" ")[0]
          message = upvoter.name + " has upvoted comments"
      end      
      prev_notification.update_attribute("message",message)
      prev_notification.update_attribute("read",false)
    end
  end

  def send_notifications_on_regnib(gnib,regnibber)
    gnib_action_upvote = 4
    user_id = gnib.user.id
    gnib_id = gnib.id
    nots = Notification.where("user_id = :user_id and gnib_id = :gnib_id and gnib_action = :gnib_action", :user_id => user_id, :gnib_id => gnib_id, :gnib_action =>gnib_action_upvote)
    if nots.empty?
      message = regnibber.name+" has regnibbed your gnib"
      Notification.create(:user_id => user_id, :gnib_id => gnib_id, :gnib_action =>gnib_action_upvote, :read => false, :message => message)
    else
      prev_notification = nots[0]
      if prev_notification.read?
          message = regnibber.name + " has regnibbed your gnib"
      else
          prev_regnibber_name = prev_notification.message.split(" ")[0]
      message = regnibber.name + " has regnibbed your gnib"
      end        
      prev_notification.update_attribute("message",message)
      prev_notification.update_attribute("read",false)
    end
  end


  def send_notifications_on_upgnib(gnib,upvoter)

    gnib_action_upvote = 2
    user_id = gnib.user.id
    gnib_id = gnib.id
    nots = Notification.where("user_id = :user_id and gnib_id = :gnib_id and gnib_action = :gnib_action", :user_id => user_id, :gnib_id => gnib_id, :gnib_action =>gnib_action_upvote)
    if nots.empty?
      message = upvoter.name+" has upvoted your gnib"
      Notification.create(:user_id => user_id, :gnib_id => gnib_id, :gnib_action =>gnib_action_upvote, :read => false, :message => message)
    else
      prev_notification = nots[0]
      if prev_notification.read?
	  message = upvoter.name +  " has upvoted your gnib"       
      else
	prev_upvoter_name = prev_notification.message.split(" ")[0]
        message = upvoter.name + " has upvoted your gnib"      
      end
      
      prev_notification.update_attribute("message",message)
      prev_notification.update_attribute("read",false)
    end
  end

  def send_notifications_on_comment(gnib_id, comment)

    @gnib = Gnib.find(gnib_id)
    notify_gnib_commenters(gnib_id,comment)
    send_notifications_ontags(@gnib,comment.user, comment.description)
    gnib_owner_id = @gnib.user.id
    commenter_id = comment.user.id
    unless commenter_id == gnib_owner_id #commented on your own
      notify_gnibler(@gnib, comment)
    end
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
      message =  comment.user.name+" commented on your gnib "
      Notification.create(:user_id => user_id, :gnib_id => gnib_id, :message => message)
    else
      user_name =  comment.user.name
      message = user_name +", "+nots[0].message
      nots[0].update_attribute("message",message)
      nots[0].update_attribute("read",false)
    end
    user = gnib.user
   	link = message +"</br> <a href = 'http://www.gnibl.com/gnibs/display?gnib_id=#{gnib_id}&sec=#{user.emailsecret}'> click here to go to gnibl </a>"

    m = UserMailer.delay.email_notification(user,link)

  rescue Exception => e
    puts "Exception #{e}"
  end


  def notify_gnib_commenters(gnib_id, comment_src)
    gnib = Gnib.find(gnib_id)
    commenter = comment_src.user
    commenter_name = commenter.name
    follower_ids = commenter.followers.map(&:id)
    comments = Comment.where({:gnib_id => gnib_id, :user_id => follower_ids})
    comments.each do |comment|
      past_commenter_id = comment.user_id
      unless past_commenter_id == gnib.user.id
        notify_past_commenter(past_commenter_id, gnib_id, commenter_name)
      end
    end
  end

  def notify_past_commenter(past_commenter_id, gnib_id, commenter_name)
    nots = Notification.where("user_id = :user_id and gnib_id = :gnib_id", :user_id => past_commenter_id, :gnib_id => gnib_id)
    message = ''
    if nots.empty?
      message =  commenter_name+" posted a comment "
      Notification.create(:user_id => past_commenter_id, :gnib_id => gnib_id, :message => message)
    else
      message =  commenter_name+" posted a comment " +", "+nots[0].message
      nots[0].update_attribute("message",message)
      nots[0].update_attribute("read",false)
    end
  rescue Exception => e
    puts "Exception #{e}"
  end

  def send_notifications(gnib,from, to)
    sender = from
    target_users = sender.followers.where("name ilike :to or surname ilike :to or username ilike :to", :to => "%"+to+"%")
    gnib_id = gnib.id
    message = sender.name + " has tagged you "
    target_users.each do |target_user|
      user_id = target_user.id
      nots = Notification.where("user_id = :user_id and gnib_id = :gnib_id", :user_id => user_id, :gnib_id => gnib_id)
      if nots.empty?
        message = sender.name+" tagged you in a gnib"
        Notification.create(:user_id => target_user.id, :gnib_id => gnib.id, :message => message)
        link = message +"</br> <a href = 'http://www.gnibl.com/gnibs/display?gnib_id=#{gnib_id}&sec=#{target_user.emailsecret}'> click here to go to gnibl </a>"    	
        m = UserMailer.delay.email_notification(target_user,link)
      end
    end
  end

  def  send_verification_email(url, user)
    m = UserMailer::send_verification_code(url, user)
    m.deliver
  end

  def invite_by_mail(gnib, email)
    @gnib =gnib
    m = UserMailer::invite_to_gnibl(@gnib,email)
    m.deliver
  end
  def getRandomString
    o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    string  =  (0...50).map{ o[rand(o.length)] }.join
  end

end
