class PartiesController < ApplicationController

  def index
    @title = 'Parties'
    @parties = Party.all
  end
  
  def show
    @party = Party.find_by_url_slug( params[:url_slug] )
    @title = @party.official_name
    @genders = User.users_by_party(@party)
  end

end
