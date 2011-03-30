require 'spec_helper'

describe YourStageImporter do
  
  before(:each) do
    @ysi = YourStageImporter.new
  end
  
  it "should return version of MySQL source" do
    version = @ysi.sql("SELECT VERSION() as version")
    version.first["version"].to_s.should match /(\A5\.)/xi
  end
  
  it "should generate days table" do
   days = @ysi.generate_year_records!
   days.size.should be > 300
  end
  
  it "should get all available dates" do
    dates = @ysi.available_dates
    dates.size.should > 1
    
    facts = @ysi.fact_for_date({'year' => 2011, 'month' => 2, 'day' => 24})
    facts.size.should be > 5
  end
  
  it "should get location from IP" do
    location = @ysi.location_geoip_data "84.255.196.34"
    puts location.inspect
    
  end
  
  it "should build facts table" do
    @ysi.available_dates(1).each do |date|
      @ysi.fact_for_date(date).each do |vote|
        
        image = Image.find_or_create_by_image(vote['image'])
        image.store = vote['title']
        location = Location.find_or_create_by_ip_and_latitude_and_longitude(vote['ip'],0,0)
        period = Period.find_or_create_by_year_and_month_and_day(
          date['year'].to_i, date['month'].to_i, date['day'].to_i
        )
        
        new_vote = Vote.new(
          :votes => 1,
          :image => image,
          :location => location,
          :period => period
        )
        
        new_vote.should be_valid
        new_vote.save
      end
    end
  end
  
  it "should build get all GeoIP locations" do
    i=0
    Location.all.each do |location|
      location_new = @ysi.location_geoip_data location['ip']
      location.update_attributes location_new
      location.save
      i = i+1
    end
    
    i.should be > 10
  end
  
end