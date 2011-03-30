class Period < ActiveRecord::Base
  set_table_name :dim_periods
  
  has_many :votes
  
  validates_numericality_of :year, :greater_than => 0
  validates_numericality_of :month, :greater_than => 0, :less_than => 13
  validates_numericality_of :day, :greater_than => 0, :less_than => 32
  
end
