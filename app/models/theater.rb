class Theater < ActiveRecord::Base
  mount_uploader :movie, MovieUploader
end
