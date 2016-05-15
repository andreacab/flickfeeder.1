class Organization < ActiveRecord::Base
  has_many :users
  has_many :f_fdevices
  has_many :events
end
