class Location < ActiveRecord::Base
  set_table_name :dim_locations
  
  has_many :votes
  
  validates_numericality_of :latitude
  validates_numericality_of :longitude
  
  validates_uniqueness_of :ip
  
  validates_length_of :country, :maximum => 100
  validates_length_of :region, :maximum => 100
  validates_length_of :city, :maximum => 100
  validates_length_of :zip, :maximum => 100
  
end
