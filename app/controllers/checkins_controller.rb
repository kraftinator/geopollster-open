class CheckinsController < ApplicationController

  protect_from_forgery :only => []

	def push
	
    push_checkin = JSON.parse( params['checkin'] )
    if !Checkin.duplicate( push_checkin['id'] )
      user = User.find_by_foursquare_guid( push_checkin['user']['id'] )
      if ( user ) and ( !user.deleted_at ) and ( push_checkin['venue'] ) and ( user.foursquare_access_token != "UNKNOWN" )

        if user.connected_app_notify
          venue = Venue.find_by_foursquare_guid( push_checkin['venue']['id'] )
          if venue and venue.company and venue.company.is_partisan?
	          client = authenticated_client( user.foursquare_access_token )
            response = client.reply( push_checkin['id'], options={ :text => venue.company.reply_text, :url => venue.company.url } )
            CLEAN_LOG.info "Sent reply to user #{ user.id } for #{ venue.company.short_name }"
          else
            company = Company.identify( push_checkin['venue']['name'] )
            if company and company.is_partisan?
	            client = authenticated_client( user.foursquare_access_token )
              response = client.reply( push_checkin['id'], options={ :text => company.reply_text, :url => company.url } )
              CLEAN_LOG.info "Sent reply to user #{ user.id } for #{ company.short_name }"
            end
          end
        end ## connected_app_notify
      
        ## Don't process private check-ins
        if !( push_checkin['private'] and push_checkin['private'] == true )
           
          ##Create objects
          if company and !venue
            country = Country.identify( push_checkin['venue']['location']['cc'], push_checkin['venue']['location']['country'] )
            ## Create venue
            venue = Venue.create(
                :foursquare_guid => push_checkin['venue']['id'],
                :name => push_checkin['venue']['name'],
                :company => company,
                :category => Category.identify( push_checkin['venue']['categories'] ),
                :zip_code => country.usa ? ZipCode.identify( push_checkin['venue']['location']['lat'], push_checkin['venue']['location']['lng'] ) : nil,
                :country => country
            )
            ## Create checkin
            checkin = Checkin.create(
                :foursquare_guid => push_checkin['id'],
                :user => user,
                :venue => venue,
                :checked_in_at => Time.at( push_checkin['createdAt'] )
            )
            checkin.user.calculate_points
          elsif venue and venue.company
            if venue.country.usa and !venue.zip_code
              ## Get zip code
              zip_code = ZipCode.identify( push_checkin['venue']['location']['lat'], push_checkin['venue']['location']['lng'] )
              if zip_code
                venue.update_attribute( :zip_code, zip_code )
              end
            end
            ## Create checkin
            checkin = Checkin.create(
                :foursquare_guid => push_checkin['id'],
                :user => user,
                :venue => venue,
                :checked_in_at => Time.at( push_checkin['createdAt'] )
            )
            checkin.user.calculate_points
          end
           
          ## Vote
          country = Country.identify( push_checkin['venue']['location']['cc'], push_checkin['venue']['location']['country'] )
          if user.voter and country.usa and push_checkin['venue']
            c = {}
            c[:id] = push_checkin['id'] ## checkin foursquare id
            c[:created_at] = push_checkin['createdAt']
            c[:venue_id] = push_checkin['venue']['id'] ## venue foursquare id
            c[:venue_name] = push_checkin['venue']['name'] ## venue foursquare name
            c[:venue_categories] = push_checkin['venue']['categories'] ## venue foursquare categories
            c[:venue_location_lat] = push_checkin['venue']['location']['lat'] ## latitude
            c[:venue_location_lng] = push_checkin['venue']['location']['lng'] ## longitude
            Vote.generate( c, country, user )
          end
           
        else
          ##Private checkin
          CLEAN_LOG.error "Private check-in for user #{ user.id }. Checkin ID =  #{ push_checkin['id'] }"
        end
      end ##User is eligible
    else
      ##Duplicate checkin
      CLEAN_LOG.error "Duplicate push request. Checkin ID =  #{ push_checkin['id'] }"
    end
		
		render :nothing => true
		
	end ## push

end ## class
