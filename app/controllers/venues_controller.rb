class VenuesController < ApplicationController

  def show
    @venue = Venue.find_by_foursquare_guid( params[:foursquare_guid] )
    @title = "#{ @venue.name } - #{ @venue.city.full_name }"
    @venue_results = @venue.polling
    @parties = Party.find(:all)
  end

end
