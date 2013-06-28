class UserMailer < ActionMailer::Base
  require 'base64'
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
end