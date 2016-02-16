class StatesController < ApplicationController

  def index
    @title = 'States'
    @states = State.all
  end

  def show
    @state = State.find_by_url_slug( params['url_slug'] )
    @title = "#{ @state.name }"
    @state.party_id = 0 if !@state.party_id
    @power_changes = PowerChange.recent( 10, @state )
    @state_results = @state.polling
    @parties = Party.find(:all)
  end

end
