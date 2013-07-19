class Notification < ActiveRecord::Base
  require 'gnibl_util'
  include GniblUtil

  attr_accessible :gnib_id, :message, :user_id, :read, :gnib_action
  belongs_to :user
  belongs_to :gnib
  def parsed_message
    comment = self.message
    final_comment = ""
    len = comment.length
    pos = -1
    lastpos = 0
    while (pos = comment.index('@',pos+1))
      tag =  comment[pos+1 ..len].split(" ")[0]
      replacement_string = "<a style='color: #17aeff' href = '/users/search?uid="+tag+"'>"+tag+"</a>"
      final_comment += comment[lastpos..pos] + replacement_string
      lastpos = pos +1+tag.length
    end
    if lastpos < len
      final_comment += comment[lastpos..len]
    end
    return final_comment.html_safe
  end
end
