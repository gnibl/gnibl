module GniblUtil
def inform_tagged_gniblers(gnib)
comment = gnib.description
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
send_notifications(gnib, tag)
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

def notify_gnibler(gnib_id, comment)
@gnib = Gnib.find(gnib_id)
user_id = @gnib.user.id
nots = Notification.where("user_id = :user_id and gnib_id = :gnib_id", :user_id => user_id, :gnib_id => gnib_id)
        if nots.empty?
          message = comment.user.name+" commented on your gnib"
          Notification.create(:user_id => user_id, :gnib_id => gnib_id, :message => message)          
          else
          msg = comment.user.name +", "+nots.message
          nots[0].update_attribute("message",msg)
         end

end



def send_notifications(gnib, to)
sender = gnib.user
target_users = sender.followers.where("name like :to or surname like :to or username like :to", :to => "%"+to+"%")
gnib_id = gnib.id
message = sender.name + " has tagged you "
target_users.each do |target_user|
user_id = target_user.id
     nots = Notification.where("user_id = :user_id and gnib_id = :gnib_id", :user_id => user_id, :gnib_id => gnib_id)
        if nots.empty?
          message = gnib.user.name+" tagged you in a gnib"
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
