require 'custom_foursquare'

class ApplicationController < ActionController::Base

  before_filter :load_current_user
  protect_from_forgery
  
  def authenticated_client( access_token )
    if access_token
      client = CustomFoursquare::Client.new( :oauth_token => access_token )
    else
      client = CustomFoursquare::Client.new( :client_id => FOURSQUARE_CONSUMER_KEY, :client_secret => FOURSQUARE_CONSUMER_SECRET )
    end
    client.ssl[:ca_path]= "/etc/ssl/certs"
    client
  end
  
  def current_user
    if session['user_id']
    	return User.find( session['user_id'] )
    else
    	return nil
    end
  end
  
  def load_current_user
    @current_user = current_user
  end
  
  def login_required
    if session['user_id']
      return true
    else      
      session[:return_to]=request.request_uri
      redirect_to :controller => "welcome"
      return false 
    end
  end
   
  ## The request object breaks rails console when it's in environment config file.
  ## So put it here.
  def oauth_callback
    if Rails.env == 'production'
      return "http://#{request.host}/oauth/callback"
    elsif Rails.env == 'staging'
      return "http://#{request.host}/oauth/callback"
    else
      return "http://#{request.host}:#{request.port.to_s}/oauth/callback"
    end
  end
  
  def twitter_oauth_callback
    if Rails.env == 'production'
      return "http://#{request.host}/oauth/twitter_callback"
    elsif Rails.env == 'staging'
      return "http://#{request.host}/oauth/twitter_callback"
    else
      return "http://#{request.host}:#{request.port.to_s}/oauth/twitter_callback"
    end
  end

end
