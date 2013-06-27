class UserMailer < ActionMailer::Base
  require 'base64'
  default :from => "gniblteam@gmail.com"

  def invite_to_gnibl(user)
    @user = user
    safe_name = "fb.jpg"
    file =  File.read(Rails.root.join("app/assets/images/facebook.jpg"))
    attachments['fb.jpg'] = {
      :data => Base64.encode64(file),
      :encoding => "base64",
      :mime_type => "image/jpg",
      :parts_order =>["text/plain","image/jpg"],
      :content_disposition => "attachment; filename = 'fb.jpg'"
    }
    mail(:to => "kenn <kennmunenetest@gmail.com>", :subject=> "invite to gnibl no att")

    #:content => Base64.b64encode(File.read(Rails.root.join("app/assets/images/maress.jpg")))
    #:data =>File.read(Rails.root.join("app/assets/images/maress.jpg")),
  end
end
