class DashboardController < ApplicationController
  
  respond_to :html, :json
  
  before_filter :load_olap_subsystem
  
  def index
    params[:rows] ||= '[Locations].children' 
    params[:columns] ||= '[Images].children' 
    params[:where] ||= '[Time].[2011]'

    @query = @yso.olap.
      from("Votes").
      columns(params[:columns]).
      rows(params[:rows]).
      where(params[:where]).
      order('[Measures].[Votes]',:desc)

    begin
      @result = @query.execute
      @cube = @yso.olap.cube('Votes')
    rescue Exception => @mondrian_exception
    
    end
    
    respond_with(@result) do |f|
      f.json do
        
        if @mondrian_exception == nil
          return render :json => {
            :axes_count => @result.axes_count,
            :column_full_names => @result.column_full_names,
            :column_names => @result.column_names,
            :row_names => @result.row_names,
            :row_full_names => @result.row_full_names,
            :values => @result.values.map{|v| v.map{ |i| i.to_i } },
            :cube => {
              :dimension_names => @cube.dimension_names,
              :dimensions => @cube.dimension_names.map do |d|
                @cube.dimension(d).hierarchy_names
              end
            }
          }
        else
          return render :json => {
           :exception => @mondrian_exception.to_s
          }
        end
      end
    end

  end

  private 
    def load_olap_subsystem
      @yso = YourStageOlap.new
    end

end
