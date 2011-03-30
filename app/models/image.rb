class Image < ActiveRecord::Base
  set_table_name :dim_images
  
  has_many :votes
  
  validates_presence_of :image
  validates_length_of :store, :maximum => 100
  validates_length_of :image, :maximum => 255
  
end
