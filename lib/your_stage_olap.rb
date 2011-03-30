require "rubygems"
require "mondrian-olap"
require "jdbc/mysql"

class YourStageOlap
  
  attr_accessor :schema, :olap
  
  def initialize()
    load_default_schema
    
    @olap = Mondrian::OLAP::Connection.create(
        :driver => 'mysql',
        :host => 'localhost',
        :database => 'ysstats_development', # 'ysstats_test',
        :username => 'ysstats',
        :password => '',
        :schema => @schema
    )
    
    return @olap
  end
  
  def load_default_schema
    @schema = Mondrian::OLAP::Schema.define do
      cube 'Votes' do
        table 'fact_votes'
        
        dimension 'Locations', :foreign_key => 'dim_location_id' do
          hierarchy :has_all => true, :all_member_name => 'All Locations', :primary_key => 'id' do
            table 'dim_locations'
            level 'Country', :column => 'country', :unique_members => true
            level 'Region', :column => 'region', :unique_members => true
            level 'City', :column => 'city', :unique_members => false
            level 'IP', :column => 'ip', :unique_members => false
          end
        end
        
        dimension 'Images', :foreign_key => 'dim_image_id' do
          hierarchy :has_all => true, :all_member_name => 'All Images', :primary_key => 'id' do
            table 'dim_images'
            level 'Stores', :column => 'store', :unique_members => true
            level 'Image', :column => 'image', :unique_members => true
          end
        end
        
        dimension 'Time', :foreign_key => 'dim_period_id', :type => 'TimeDimension' do
          hierarchy :has_all => false, :primary_key => 'id' do
            table 'dim_periods'
            level 'Year', :column => 'year', :type => 'Numeric', :unique_members => true, :level_type => 'TimeYears'
            level 'Month', :column => 'month', :type => 'Numeric', :unique_members => false, :level_type => 'TimeMonths'
            #level 'Day', :column => 'month', :type => 'Numeric', :unique_members => false, :level_type => 'TimeMonths'
          end
        end
        
        measure 'Votes', :column => 'votes', :aggregator => 'sum'
        
      end
    end
  end
  
end