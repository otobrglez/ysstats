require 'spec_helper'

describe Period do
  
  specify do
    pe = Period.new
    pe.should_not be_valid
    
    pe.year = 2011
    pe.month = 12
    pe.day = 31
    
    pe.should be_valid
    
    pe.year = -2011
    
    pe.should_not be_valid
    
  end
  
end