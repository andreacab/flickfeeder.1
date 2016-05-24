class Media < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  belongs_to :event
  belongs_to :token

  has_and_belongs_to_many :labels
  mount_uploader :url, MediasUploader

end
