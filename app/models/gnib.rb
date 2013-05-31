class Gnib < ActiveRecord::Base
  attr_accessible :description, :image, :landmark, :title, :visibility
  belongs_to :user
  validates :user_id, presence: true
  validates :description, presence:true, length:{ maximum: 77}

  default_scope order: 'gnibs.created_at DESC'

    mount_uploader :image, GnibUploader
end
