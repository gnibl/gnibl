class User < ActiveRecord::Base
  attr_accessible :name
  has_many:authorization
def self.create_from_hash!(hash)
create(:name => hash['name'])
end
end
