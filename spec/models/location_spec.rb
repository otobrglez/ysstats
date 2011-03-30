require 'spec_helper'

describe Location do
  
  specify do
    l = Location.new
    l.should_not be_valid
    
    l.latitude = -100.2
    l.longitude = -100.3
    
    l.should be_valid
    
  end
  
end