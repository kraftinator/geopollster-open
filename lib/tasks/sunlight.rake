require 'custom_transparency'

namespace :sunlight do
  
  desc 'Load all aggregate party contribution data from Sunlight'
  task 'load' => :environment do
    CustomTransparency.api_key = SUNLIGHT_API_KEY
    companies = Company.find( :all, :conditions => ["sunlight_guid is not null"] )
    companies.each do |company|
      party_contribution = company.party_contribution
      if party_contribution
        party_contribution.update_attributes( :dem_amount => 0, :rep_amount => 0, :other_amount => 0 )
      else
        party_contribution = PartyContribution.create( :company => company )
      end
      #update_company( party_contribution, '2010' )
      #update_company( party_contribution, '2012' )
      update_company( party_contribution, '-1' )
    end
  end #load
  
  desc 'Create aggregate party contribution data from Sunlight'
  task 'create' => :environment do
    CustomTransparency.api_key = SUNLIGHT_API_KEY
    companies = Company.find( :all, :conditions => ["sunlight_guid is not null"] )
    companies.each do |company|
      party_contribution = company.party_contribution
      if !party_contribution
        party_contribution = PartyContribution.create( :company => company )
        #update_company( party_contribution, '2010' )
        #update_company( party_contribution, '2012' )
        update_company( party_contribution, '-1' )
      end
    end
  end #create
  
  private
  
  def update_company( party_contribution, election_cycle )
    ## Get party breakdown data from sunlight
    pb = CustomTransparency::Client.org_party_breakdown( party_contribution.company.sunlight_guid, :cycle => [election_cycle] )
    if pb
      ## Initialize party breakdowns
      dem_amount = party_contribution.dem_amount
      rep_amount = party_contribution.rep_amount
      other_amount = party_contribution.other_amount
      ## Add new breakdown data to existing data
      if pb.dem_amount
        dem_amount += pb.dem_amount
      end
      if pb.rep_amount
        rep_amount += pb.rep_amount
      end
      if pb.other_amount
        other_amount += pb.other_amount
      end
      ## Update party contribution data
      party_contribution.update_attributes(
 					:dem_amount => dem_amount,
					:rep_amount => rep_amount,
					:other_amount => other_amount
			)         
			puts "ADDED PARTY CONTRIBUTION DATA: #{ party_contribution.company.name } = #{ party_contribution.total_amount }"
    else
      puts "WARNING: Could not get party breakdown data for #{ party_contribution.company.name }"
    end
  end #update_company

end