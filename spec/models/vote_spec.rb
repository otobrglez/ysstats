require 'spec_helper'

describe Vote do
  
  specify do
    v = Vote.new
    v.should_not be_valid
  end
  
end