namespace :ysstats do
  
  desc "Build OLAP cube with YourStageImporter"
  task :build_cube => :environment do
    puts "Building new OLAP cube"
    
    @ysi = YourStageImporter.new
    
    @ysi.available_dates.each do |date|
      puts "#{date['year']}-#{date['month']}-#{date['day']}"
      
      @ysi.fact_for_date(date).each do |vote|
        image = Image.find_or_create_by_image(vote['image'])
        image['store'] = vote['title']
        image.save
        location = Location.find_or_create_by_ip_and_latitude_and_longitude(vote['ip'],0,0)
        period = Period.find_or_create_by_year_and_month_and_day(
          date['year'].to_i,
          date['month'].to_i,
          date['day'].to_i)
        
        new_vote = Vote.create!(:votes => 1, :image => image, :location => location, :period => period)
      end
    end
  end
  
  desc "Update locations dimension with GeoIP data"
  task :update_with_geoip => :environment do
    @ysi = YourStageImporter.new
    i=0
    Location.all.each do |location|
      location_new = @ysi.location_geoip_data location['ip']
      location.update_attributes location_new
      location.save
      puts "#{i} : #{location['ip']}"
      i = i+1
    end
  end
  
  desc "Get GeoIP data for IP"
  task :get_geoip => :environment do
    @ysi = YourStageImporter.new
    data = @ysi.location_geoip_data ENV['ip']
    puts data.inspect
  end
  
end