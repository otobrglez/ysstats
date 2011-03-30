class Vote < ActiveRecord::Base
  set_table_name :fact_votes
  
  belongs_to :image, :class_name => "Image", :foreign_key => "dim_image_id"
  belongs_to :location, :class_name => "Location", :foreign_key => "dim_location_id"
  belongs_to :period, :class_name => "Period", :foreign_key => "dim_period_id"

  validates_presence_of :image
  validates_presence_of :location
  validates_presence_of :period
  
end
