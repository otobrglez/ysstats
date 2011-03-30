require 'rubygems'
#require 'ruby-debug'
require 'json'
require 'singleton'
require 'active_record'
require 'logger'
require 'date'
require 'time'
require 'net/http'

class YourStageImporter
  
  attr_accessor :poll, :connection
  
  def initialize()
    #ActiveRecord::Base.logger = Logger.new(STDOUT) #'log/debug.log'
    ##ActiveRecord::Base.configurations["source"] =
    #db_config = YAML::load(IO.read('config/database.yml'))
    #@poll ||= ActiveRecord::Base.establish_connection db_config["source"]
    
    @connection = ActiveRecord::Base.connection
    nil
  end
  
  def sql(query)
    @connection.select_all(query)
  end
  
  def available_dates(limit=nil)
    limit = "LIMIT #{limit}" if limit != nil
    
    @connection.select_all "
      SELECT
      	YEAR(FROM_UNIXTIME(v.crdate)) as year,
      	MONTH(FROM_UNIXTIME(v.crdate)) as month,
      	DAY(FROM_UNIXTIME(v.crdate)) as day
      FROM
      	ysstats_data.tx_t3fbkr_vote v
      WHERE
      	v.hidden = 0 AND v.deleted = 0
      GROUP BY
      	DATE(FROM_UNIXTIME(v.crdate))
      ORDER BY
      	v.crdate ASC
      #{limit}
    "
  end
  
  def fact_for_date(date)
    @connection.select_all "
      SELECT
      	v.crdate, v.ip, p.title, im.image, FROM_UNIXTIME(v.crdate) as date
      FROM
      	ysstats_data.tx_t3fbkr_vote v
      LEFT JOIN (
      	ysstats_data.pages p, ysstats_data.tx_t3fbkr_image im
      ) ON
      	v.pid = p.uid AND	v.record_id = im.uid
      WHERE
      	v.deleted = 0 AND v.hidden = 0 AND
      	DATE('#{date['year']}-#{date['month']}-#{date['day']}') = DATE(FROM_UNIXTIME(v.crdate))
      ORDER BY
      	v.crdate ASC
    "
  end
  
  def generate_year_records!(year=nil)
    year = Date.today unless year
    (year.at_beginning_of_year...year.at_end_of_year).map do |d|
      {
        :year => d.strftime('%Y').to_i,
        :month => d.strftime('%m').to_i,
        :day => d.strftime('%d').to_i
      }
    end
  end
  
  def location_geoip_data(ip)
    data = Net::HTTP.get_response(URI.parse("http://freegeoip.net/json/#{ip}")).body
    f_data = JSON.parse(data)
    
    {
      :country => f_data['country_name'],
      :region => f_data['region_name'],
      :city => f_data['city'],
      :zip => f_data['zipcode'],
      :ip => ip,
      :latitude => f_data['latitude'],
      :longitude => f_data['longitude']
    }
  end
  
  
end