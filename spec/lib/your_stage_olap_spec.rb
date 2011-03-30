require 'spec_helper'

describe YourStageOlap do

  before(:each) do
    @yso = YourStageOlap.new
  end
  
  it "should connect to database" do

    results = @yso.olap.from('Votes').
      columns('[Measures].[Votes]').
      rows('[Locations].children').
      where('[Time].[2011]').
      execute
    
    puts results.values
    
    cube = @yso.olap.cube('Votes')
    
    cube.inspect
    
    puts cube.dimension_names
    puts cube.dimensions
    puts cube.dimension('Locations').hierarchy.levels
  end

end