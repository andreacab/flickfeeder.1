class Media < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  belongs_to :event
  has_and_belongs_to_many :labels
end
