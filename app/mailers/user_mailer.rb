class UserMailer < ActionMailer::Base
  require 'base64'
  require 'delayed_job'
  default :from => "gniblteam@gmail.com"
  def invite_to_gnibl(gnib, recipient)
    @gnib = gnib
    @comments = Comment.where("gnib_id = #{@gnib.id}").order("created_at DESC").limit(4)
    @name = recipient.split("@")[0]
    to = @name +"<"+recipient+">"
    mail(:to => to,
      :subject=> "invitation to gnibl",
      :content_type => "text/html")
  end

 def send_verification_code(url,user)
   message = "Thank you for joining gnibl, 
            <a href = 'http://#{url}/users/validateemail?code=#{user.validation_code}'>
            click this link</a> 
           to verify your email address and get gnibbing"
   to = user.name+"<"+user.email+">"
   mail(:to => to,
      :subject=> "verify email address: Gnibl.com ",
      :content_type => "text/html",
      :body => message)
end

def email_notification(user,message)
	link = message +"</br> <a href = 'http://www.gnibl.com/users/#{user.username}'> click here to go to gnibl </a>"
	to = user.name + "<"+ user.email + ">"
	mail(:to => to,
             :subject=> "Gnibl: "+message[0..15],
             :content_type => "text/html",
             :body => link)
end

end
