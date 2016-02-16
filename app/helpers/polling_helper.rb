module PollingHelper

  def show_power_change( pc )
    
    if pc.object.instance_of? Venue
      announcement = "#{ party_link( pc.winning_party) } #{ seize_control } #{ venue_link( pc.object ) } in #{ city_link( pc.object.city ) }"
    elsif pc.object.instance_of? City
      announcement = "#{ party_link( pc.winning_party) } #{ seize_control } #{ city_link( pc.object ) }"
    elsif pc.object.instance_of? State
      announcement = "#{ party_link( pc.winning_party) } #{ seize_control } of #{ state_link( pc.object ) }"
    elsif pc.object.instance_of? Category
      announcement = "#{ party_link( pc.winning_party) } #{ seize_control } #{ category_link( pc.object ) }"
    elsif pc.object.instance_of? Country
      announcement = "#{ party_link( pc.winning_party) } #{ seize_control } the United States"
    end
    
    announcement += " from the #{ party_link( pc.losing_party ) }" if pc.losing_party
    announcement += '.'
    
  end
  
  def seize_control
    "seize control of"
  end
  
  def category_link( category )
    '<a href="/categories/' + category.url_slug + '">' + category.display_name + '</a>'
  end
  
  def venue_link( venue )
    '<a href="/venues/' + venue.foursquare_guid + '">' + venue.name + '</a>'
  end
  
  def state_link( state )
    '<a href="/states/' + state.url_slug + '">' + state.name + '</a>'
  end
 
  def city_link( city )
    "<a href=\"/cities/#{ city.to_param }\">#{ city.full_name }</a>"
  end
 
  def party_link( party )
    '<a href="/parties/' + party.url_slug + '">' + party.member_name_plural + '</a>'
  end
  
  def party_plural_link( party )
    '<a href="/parties/' + party.id.to_s + '">' + party.member_name_plural + '</a>'
  end

end
