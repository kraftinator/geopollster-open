class UsersController < ApplicationController

  before_filter :login_required, :except => [:login]
  before_filter :active_required, :except => [:login, :signup, :activate, :cancel_signup, :logout]

	def login
		
    client = authenticated_client( session[:access_token] )
		foursquare_user = client.user( 'self' )
    user = User.find_by_foursquare_guid( foursquare_user['id'] )

    if user
    	# Update existing user
      if user.update_attributes( 
      			:foursquare_access_token => session[:access_token],
      			:last_login => Time.now,
    	  		:deleted_at => nil,
    		  	:gender => Gender.convert_foursquare_gender( foursquare_user['gender'] ),
    			  :photo_url => foursquare_user['photo']
      			)
   			session[:user_id] = user.id
    		session[:access_token] = nil
  	  	if user.active?
	        user.clear_cache
			    ## Analyze checkin history and set cache.
 	        user.set_checkin_history( client )
          return redirect_to :action => 'home'
  	    else
	        return redirect_to :action => 'signup'
	      end
		  else
		    #TODO
  		end

    else
      # Create new user
      user = User.new( 
      		:foursquare_guid => foursquare_user['id'], 
      		:foursquare_access_token => session[:access_token],
      		:first_name => foursquare_user['firstName'],
      		:last_name => foursquare_user['lastName'] ? foursquare_user['lastName'] : '',
      		:last_login => Time.now,
      		:gender => Gender.convert_foursquare_gender( foursquare_user['gender'] ),
      		:photo_url => foursquare_user['photo'],
      		:email => foursquare_user.contact.email
      		)
      if user.save( :validate => false )
				session[:user_id] = user.id
				session[:access_token] = nil
		    return redirect_to :action => 'signup'
		  else
		    #TODO
      end
		end
    
	end
	
	def cancel_signup
	  @current_user.update_attribute( :deleted_at, Time.now )
	  return redirect_to :action => 'logout'
	end
	
	def confirm_delete
	  @title = 'Confirm Delete'
	end
	
	def delete
	  @current_user.update_attributes( :deleted_at => Time.now, :active => false )
	  @current_user.clear_cache
    session['user_id'] = nil
    reset_session
    return redirect_to :controller => 'welcome', :notice => "Your account has been deleted"
	end
	
	def logout
	  @current_user.clear_cache
    session['user_id'] = nil
    reset_session
    return redirect_to :controller => 'welcome', :notice => 'You have successfully logged out'
	end

  def signup
	  @title = 'Sign Up'
	  @hide_nav = true
	  @parties = Party.all
	  @errors = params[:errors] if params[:errors]
  end

  def activate
	  if @current_user.update_attributes( params[:user] ) and @current_user.update_attribute( :active, true )
			@current_user.clear_cache
		  @current_user.set_checkin_history( authenticated_client( @current_user.foursquare_access_token ) )
	    redirect_to :action => 'home'
	  else
	    errors = @current_user.errors.first[1] if @current_user.errors.any?
	    redirect_to :action => 'signup', :errors => errors
	  end
  end
	
	def settings
	  @title = 'Settings'
	  @parties = Party.all
	  @errors = params[:errors] if params[:errors]
	end
  
  def twitter_disconnect
    @current_user.update_attributes( :twitter_oauth_token => nil, :twitter_oauth_secret => nil )
    redirect_to :controller => 'users', :action => 'home', :notice => 'Your Twitter account has been disconnected'
  end

	def update
	  if @current_user.update_attributes( params[:user] )
	    redirect_to :action => 'home'
	  else
	    errors = @current_user.errors.first[1] if @current_user.errors.any?
	    redirect_to :action => 'settings', :errors => errors
	  end
	end
	
	def refresh_checkin_history
	  @current_user.set_checkin_history( authenticated_client( @current_user.foursquare_access_token ) )
	  redirect_to :action => 'home'
	end
	
	def refresh_friends_checkins
	  @current_user.set_friend_checkins( authenticated_client( @current_user.foursquare_access_token ) )
	  redirect_to :action => 'friends_checkins'
	end
	
	def post_comment
	  @title = 'Post Comment'
	  @checkin_id = params[:checkin_id]
	  @first_name = params[:first_name]
	  @venue_name = params[:venue_name]
	  @company = Company.find_by_url_slug( params[:company] )
	  return redirect_to :action => 'friends_checkins' if !@company
	  @errors = params[:errors] if params[:errors]
	end
	
	def create_comment
	  comment = params[:comment]
	  if comment.length <= 200
	    company = Company.find_by_url_slug( params[:company] )
	    if company
	      client = @current_user.user_client
	      client.add_checkin_comment( params[:checkin_id], options={ :text => params[:comment] } )
	      return redirect_to :action => 'friends_checkins', :notice => 'Your comment has been posted'
	    else
	      return redirect_to :action => 'friends_checkins', :notice => 'We cannot process your request at this time'
	    end
	  else
	    return redirect_to :action => 'post_comment', 
	        :errors => 'Comments cannot exceed 200 characters', 
	        :checkin_id => params[:checkin_id],
	        :first_name => params[:first_name],
	        :venue_name => params[:venue_name],
	        :company => params[:company]
	  end
	end
	
	def foursquare_invite
	  @title = 'Invite via Foursquare'
    client = authenticated_client( @current_user.foursquare_access_token )
    c = client.checkin( params[:checkin_id] )
	  @checkin_id = c.id
	  @first_name = c.user.firstName
	  @venue_name = c.venue.name
	  @friend_id = c.user.id
	  @errors = params[:errors] if params[:errors]
	end
	
	def create_invite
	  comment = params[:comment]
	  if comment.length <= 200
      client = @current_user.user_client
	    client.add_checkin_comment( params[:checkin_id], options={ :text => params[:comment] } )
	    return redirect_to :action => 'friends_checkins', :notice => 'Your comment has been posted'
	  else
	    return redirect_to :action => 'foursquare_invite', :errors => 'Comments cannot exceed 200 characters', :checkin_id => params[:checkin_id]
	  end
	end

  def home
    @title = "#{ @current_user.full_name }"
    @notice = params[:notice] if params[:notice]
    @checkins = @current_user.recent_checkins
  end
  
  def friends_checkins
    @title = "Friends' Check-Ins"
    ## If there are no cached friend checkins, refresh.
    if @current_user.friend_checkins.empty?
      client = authenticated_client( @current_user.foursquare_access_token )
      @current_user.set_friend_checkins( client )
      ## Force refresh of friend checkins.
      @checkins = FriendCheckin.find_all_by_user_id( @current_user.id )
    else
      @checkins = @current_user.friend_checkins
    end
    @point = Point.calculate( @checkins )
    @notice = params[:notice] if params[:notice]
  end
  
  def friends
    @title = "Friends"
    client = authenticated_client( @current_user.foursquare_access_token )
    user_friends = client.user_friends( @current_user.foursquare_guid )
    @friends = []
    user_friends.items.each do |f|
      #next if f.type and f.type == 'page'
      next if f.relationship and f.relationship != 'friend'
      user_friend = User.find_by_foursquare_guid( f.id )
      if !user_friend or user_friend.deleted_at
        user_friend = {
            :foursquare_guid => f.id,
            :twitter_handle => f.contact.twitter,
            :facebook_guid => f.contact.facebook,
            :first_name => f.firstName,
            :last_name => f.lastName,
            :photo_url => f.photo,
            :home_city => f.homeCity
        }
      end
      @friends << user_friend
    end
    if @friends.any?
      @friends.sort! { |a,b| a[:first_name] <=> b[:first_name] }
    end
  end

  def friend
    
    ## Validate friendship
    client = authenticated_client( @current_user.foursquare_access_token )
    user_friend = client.user( params[:foursquare_id] )
    return redirect_to :action => 'friends' unless user_friend.relationship and user_friend.relationship == 'friend'
    
    @friend = User.find_by_foursquare_guid_and_deleted_at( params[:foursquare_id], nil )
    if @friend
      @title = "#{ @friend.full_name }"
      ##Do nothing, for now
    else
      @cached_friend = CachedFriend.find_by_foursquare_guid_and_user_id( params[:foursquare_id], @current_user.id )
      if @cached_friend
        @title = "#{ @cached_friend.first_name } #{ @cached_friend.last_name }"
      else
        if user_friend
          last_checkin_guid = nil
          if user_friend.checkins and user_friend.checkins.items
            last_checkin_guid = user_friend.checkins.items.first.id
          end
          @cached_friend = CachedFriend.create(
              :user => @current_user,
              :foursquare_guid => user_friend.id,
              :twitter_handle => user_friend.contact.twitter,
              :first_name => user_friend.firstName,
              :last_name => user_friend.lastName ? user_friend.lastName : '',
              :photo_url => user_friend.photo,
              :last_checkin_guid => last_checkin_guid,
              :gender => Gender.convert_foursquare_gender( user_friend.gender )
          )
          @title = "#{ @cached_friend.first_name } #{ @cached_friend.last_name }"
        else
          return redirect_to :action => 'friends'
        end
      end
    end
  end  ## end method
  
  private
  
  def active_required
    if session['user_id'] and @current_user.active?
      return true
    #elsif ( session['user_id'] and !@current_user.active? ) or ( !session['user_id'] )
    else
      session[:return_to]=request.request_uri
      redirect_to :action => "signup"
      return false
    end
  end

end
