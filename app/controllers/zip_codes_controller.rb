class ZipCodesController < ApplicationController

  def show
    @zip_code = ZipCode.find_by_name( params[:name] )
    @title = "#{ @zip_code.name } - #{ @zip_code.city.full_name }"
    @power_changes = PowerChange.recent( 10, @zip_code )
    @zip_code_results = @zip_code.polling
    @parties = Party.find(:all)
  end

end
