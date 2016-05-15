class DeviceHealth < ActiveRecord::Base
  belongs_to :f_fdevice
  belongs_to :user
end
