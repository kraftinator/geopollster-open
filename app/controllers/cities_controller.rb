class CitiesController < ApplicationController

  def show
    @city = City.find( params[:id] )
    @title = "#{ @city.full_name }"
    @power_changes = PowerChange.recent( 10, @city )
    @city.party_id = 0 if !@city.party_id
    @city_results = @city.polling
    @parties = Party.find(:all)
  end

end
