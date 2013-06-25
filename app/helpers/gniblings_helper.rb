module GniblingsHelper

def expandComment(comment)
pos = -1
final_comment = ""
len = comment.length
lastpos = 0
while (pos = comment.index('@',pos+1))
 tag =  comment[pos+1 ..len].split(" ")[0]
 replacement_string = "<a href = 'search?uid ="+tag+"'>@"+tag+"</a>"
 final_comment += comment[lastpos..pos] + replacement_string
lastpos = pos +1+tag.length
if t = tag.index('@',0) # cater for @address@gmail.com
pos = comment.index('@',pos+1)
end
end
 return final_comment
end

def inform_tagged_gniblers(user, gnib)
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
while count_tagged > -1
tag = tagged[count_tagged]
text = "you were tagged"
send_notifications(user,gnib, tag)
count_tagged -= 1
end


#find those tagged as email addresses n send email

while count_email > -1
email = emails[count_email]
text = "welcome to gnibl fellow"
invite_by_mail(user, gnib, email)
count_email -= 1
end

end

def send_notifications(from,gnib, to)
target_user = User.find_by_username(to)
message = from.name + " has tagged you "
Notification.create(:user_id => target_user.id, :gnib_id => gnib.id, :message => message)
end

def invite_by_mail(user, gnib, email)
from = user.name
message = from+ "has tagged you in this photo on gnibl.com "

end

end
