class Token < ActiveRecord::Base
  has_many :media
  has_one :user
end
