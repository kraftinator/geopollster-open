require 'net/https'

class OauthController < ApplicationController

  def twitter
    consumer = get_consumer
    @request_token = consumer.get_request_token( :oauth_callback => ( twitter_oauth_callback ) )
    session[:request_token] = @request_token.token
    session[:request_secret] = @request_token.secret
    begin
      ## Redirect to twitter
      redirect_to @request_token.authorize_url
    rescue
      redirect_to :controller => 'users', :action => 'home', :notice => "Sorry, the Twitter API rejected the request.  Please try again later."
    end
  end
  
  def twitter_callback
    consumer = get_consumer
    # Re-create the request token
    @request_token = OAuth::RequestToken.new(consumer, session[:request_token], session[:request_secret])
    # Convert the request token to an access token using the verifier Twitter gave us
    @access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    @current_user.update_attributes( :twitter_oauth_token => @access_token.token, :twitter_oauth_secret => @access_token.secret )
    redirect_to :controller => 'users', :action => 'home'
  end

  def start
    begin
    	## Redirect to foursquare
      redirect_to client.auth_code.authorize_url( :redirect_uri => oauth_callback )
    rescue
      redirect_to :controller => 'welcome', :action => 'index', :notice => "Sorry, the Foursquare API rejected the request.  Please try again later."
    end
  end

	def callback

		## Authorize
    uri = URI.parse("https://foursquare.com/oauth2/access_token?client_id=#{FOURSQUARE_CONSUMER_KEY}&client_secret=#{FOURSQUARE_CONSUMER_SECRET}&grant_type=authorization_code&redirect_uri=#{oauth_callback}&code=" + params[:code])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = JSON.parse(http.request(request).body)
    
    ## Get access token
    access_token = OAuth2::AccessToken.new(client, response["access_token"])
    session[:access_token] = access_token.token

		## Redirect to login    
    redirect_to :controller => 'users', :action => 'login'
    
	end

  protected

  def client
    @client ||= OAuth2::Client.new(
      FOURSQUARE_CONSUMER_KEY, 
      FOURSQUARE_CONSUMER_SECRET, 
      :site => 'http://foursquare.com/v2/',
      :request_token_path => "/oauth2/request_token",
      :access_token_path  => "/oauth2/access_token",
      :authorize_path     => "/oauth2/authenticate?response_type=code",
      :authorize_url => "/oauth2/authorize",
      :parse_json => true
    )
  end
  
  def get_consumer
    OAuth::Consumer.new(
      Twitter.consumer_key, 
      Twitter.consumer_secret, 
      {:site => 'http://twitter.com'}
    )
  end
  
end
