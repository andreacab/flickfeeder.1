class FFdevice < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  has_many :device_healths
end
