require 'custom_foursquare'

namespace :categories do
	
  desc 'Update categories'
  task :update => :environment do
    ##Authenticate
    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    client = CustomFoursquare::Client.new( :client_id => FOURSQUARE_CONSUMER_KEY, :client_secret => FOURSQUARE_CONSUMER_SECRET )
    client.ssl[:ca_path]= "/etc/ssl/certs"
    ##Get categories from foursquare
    categories = client.venue_categories
    ##Update database
    @count = 0
    create_top_level_categories( categories )
    process_categories( categories, nil )
  end
  
  private
  
  def update_category( category, parent_cat )
    @count += 1
    venue_category = Category.find_by_foursquare_guid( category['id'] )
    if venue_category
      venue_category.update_attribute( :icon_url, category['icon'] ) if category.icon_url != category['icon']
    elsif parent_cat
      venue_category = Category.new( :foursquare_guid => category['id'], :name => category['name'], :display_name => category['pluralName'],
          :icon_url => category['icon'], :parent_id => parent_cat.id, :eligible => true, :url_slug => category['pluralName'].gsub(/[^a-z0-9]+/i, '').downcase )
      venue_category.save
      puts "NEW CATEGORY FOUND: " + category['name']
    else
      puts "***** UNKNOWN CATEGORY TYPE *****"
    end
  end
  
  def process_categories( categories, parent_cat )
    categories.each do |category|
      #if parent_cat
      top_level_cat = Category.find_by_foursquare_guid( category['id'] )
      if !top_level_cat
        update_category( category, parent_cat )
      else
        #parent_cat = Category.find_by_name( category['name'] )
        parent_cat = top_level_cat
      end
      puts "parent_cat = #{ parent_cat.display_name }"
      # recursively iterate over categories
      process_categories( category['categories'], parent_cat ) if category['categories']
    end
  end
  
  def create_top_level_categories( categories )
    
    categories.each do |category|
      venue_category = Category.new( :foursquare_guid => category['id'], :name => category['name'], :display_name => category['pluralName'],
          :icon_url => category['icon'], :eligible => false, :url_slug => category['pluralName'].gsub(/[^a-z0-9]+/i, '').downcase )
      venue_category.save
      puts "NEW TOP-LEVEL CATEGORY FOUND: " + category['name']
    end
  
  end
  
end