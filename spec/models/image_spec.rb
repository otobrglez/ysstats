require 'spec_helper'

describe Image do
  
  specify do
    v = Image.new
    v.should_not be_valid
  end
  
end