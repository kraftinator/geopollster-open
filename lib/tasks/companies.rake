require 'csv'

namespace :companies do
  
  desc 'Update companies data'
  task :update => :environment do

    filename = 'lib/tasks/import/companies.csv'

    if Rails.env == 'development'
      CSV.foreach( filename, {:headers => true} ) do |row|
        add_company( row )
       end
    else
      CSV.open( filename, "r") do |row|
        add_company( row )
      end
    end

  end # task
  
  desc 'Update venues with newly added companies'
  task :update_venues => :environment do
    venues = Venue.find( :all, :conditions => ["company_id is null"] )
    venues.each do |venue|
      next if venue.company
      company = Company.identify( venue.name )
      if company
        venue.update_attribute( :company, company )
        puts "Added #{ company.name } for venue #{ venue.name }"
      end
    end
  end
  
  desc 'Recalculate points'
  task :update_points => :environment do
    users = User.all
    users.each do |user|
      puts "Calculating points for user #{ user.id }"
      user.calculate_points
    end
  end
  
  private
  
  def add_company( row ) 
    ## Get fields
    name = row[0]
    short_name = row[1]
    url_slug = row[2]
    twitter_handle = row[3]
    url = row[4]
    sunlight_guid = row[5]
    parent = row[6]
    alt_names = []
    alt_names << name if short_name
    alt_names << short_name
    #[7..100].each do |i|
    for i in 7..100
      alt_names << row[i] if row[i]
    end
    ## Find parent company
    if parent
      parent_company = Company.find_by_name( parent )
      if parent_company.nil?
        puts "ERROR: Cannot find parent company #{ parent } for #{ name }"
        return nil
      end
    end
    ## Validate data
    if sunlight_guid.nil? and short_name.nil?
      puts "ERROR: Company #{ name } has null sunlight_guid and null short_name"
      return nil
    elsif sunlight_guid.nil? and url_slug.nil?
      puts "ERROR: Company #{ name } has null sunlight_guid and null url_slug"
      return nil
    elsif parent_company.nil? and short_name.nil?
      puts "ERROR: Company #{ name } is parent company but has no short_name"
      return nil
    elsif parent_company.nil? and url_slug.nil?
      puts "ERROR: Company #{ name } is parent company but has no url_slug"
      return nil
    end
    ## Add/update company
    company = Company.find_by_name( name )
    if company
      ## Update company
      company.update_attributes(
          :name => name,
          :short_name => short_name,
          :url_slug => url_slug,
          :twitter_handle => twitter_handle,
          :url => url,
          :sunlight_guid => sunlight_guid,
          :parent => parent_company
        )
    else
      ## Create company
      company = Company.create(
          :name => name,
          :short_name => short_name,
          :url_slug => url_slug,
          :twitter_handle => twitter_handle,
          :url => url,
          :sunlight_guid => sunlight_guid,
          :parent => parent_company
      )
      puts "Created company #{ company.name }"
    end
    ## Add alternative company names
    alt_names.each do |alt_name|
      next unless alt_name
      alt_name = alt_name.gsub(/[^0-9A-Za-z' ''&'-]/, '')
      company_name = CompanyName.find_by_company_id_and_name( company.id, alt_name )
      unless company_name
        company_name = CompanyName.create(
            :company => company,
            :name => alt_name
        )
        puts "Added alt name #{ company_name.name } for #{ company_name.company.name }"
      end
    end
        
  end # method
  
end # namespace