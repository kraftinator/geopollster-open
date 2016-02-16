# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

## Delete previous seeds
Gender.destroy_all
Party.destroy_all
Ideology.destroy_all
PartyIdeology.destroy_all
State.destroy_all

## Create genders
gender = Gender.new :name => 'Male', :abbrev => 'M'
gender.id = 1
gender.save

gender = Gender.new :name => 'Female', :abbrev => 'F'
gender.id = 2
gender.save

gender = Gender.new :name => 'Unknown', :abbrev => 'U'
gender.id = 3
gender.save

## Create parties

# Constitution Party
party = Party.new :name => 'Constitution',
    :official_name => 'Constitution Party',
    :member_name => 'Constitutionalist', 
    :member_name_plural => 'Constitutionalists',
    :icon_url => '/images/constitution.png',
    :description => '"The goal of the Constitution Party is to restore our government to its Constitutional limits and our law to its Biblical foundations"',
    :official_url => 'http://www.constitutionparty.com',
    :facebook_url => 'http://www.facebook.com/TheConstitutionParty',
    :twitter_url => 'http://www.twitter.com/CnstitutionPrty',
    :youtube_url => 'http://www.youtube.com/user/ConstitutionParty',
    :wikipedia_url => 'http://en.wikipedia.org/wiki/Constitution_Party_(United_States)',
    :url_slug => 'constitution-party'
party.id = 1
party.save

# Democratic Party
party = Party.new :name => 'Democratic',
    :official_name => 'Democratic Party',
    :member_name => 'Democrat', 
    :member_name_plural => 'Democrats',
    :icon_url => '/images/democratic.png',
    :description => 'The Democratic Party is committed to "an agenda that emphasizes the strong economic growth, affordable health care for all Americans, retirement security, open, honest and accountable government, and securing our nation while protecting our civil rights and liberties."',
    :official_url => 'http://www.democrats.org',
    :facebook_url => 'http://www.facebook.com/democrats',
    :twitter_url => 'http://twitter.com/TheDemocrats',
    :youtube_url => 'http://www.youtube.com/democraticvideo',
    :wikipedia_url => 'http://en.wikipedia.org/wiki/Democratic_Party_(United_States)',
    :url_slug => 'democratic-party'
party.id = 2
party.save

# Green Party
party = Party.new :name => 'Green',
    :official_name => 'Green Party',
    :member_name => 'Green', 
    :member_name_plural => 'Greens',
    :icon_url => '/images/green.png',
    :description => '"The Green Party of the United States is a federation of state Green Parties committed to environmentalism, non-violence, social justice and grassroots organizing"',
    :official_url => 'http://www.gp.org',
    :facebook_url => 'http://www.facebook.com/GreenPartyUS',
    :twitter_url => 'http://twitter.com/gpus',
    :youtube_url => 'http://www.youtube.com/GreenPartyVideos',
    :wikipedia_url => 'http://en.wikipedia.org/wiki/United_States_Green_Party',
    :url_slug => 'green-party'
party.id = 3
party.save

# Libertarian Party
party = Party.new :name => 'Libertarian',
    :official_name => 'Libertarian Party',
    :member_name => 'Libertarian', 
    :member_name_plural => 'Libertarians',
    :icon_url => '/images/libertarian.png',
    :description => '"Our vision is for a world in which all individuals can freely exercise the natural right of sole dominion over their own lives, liberty and property"',
    :official_url => 'http://www.lp.org',
    :facebook_url => 'http://www.facebook.com/libertarians',
    :twitter_url => 'http://twitter.com/LPNational',
    :youtube_url => 'http://www.youtube.com/user/libertarianparty',
    :wikipedia_url => 'http://en.wikipedia.org/wiki/Libertarian_Party_(United_States)',
    :url_slug => 'libertarian-party'
party.id = 4
party.save

# Republican Party
party = Party.new :name => 'Republican',
    :official_name => 'Republican Party',
    :member_name => 'Republican', 
    :member_name_plural => 'Republicans',
    :icon_url => '/images/republican.png',
    :description => 'The Republican Party stands "for lower taxes, limited government, and a strong national defense."',
    :official_url => 'http://www.gop.com',
    :facebook_url => 'http://www.facebook.com/GOP',
    :twitter_url => 'http://twitter.com/gop',
    :youtube_url => 'http://www.youtube.com/rnc',
    :wikipedia_url => 'http://en.wikipedia.org/wiki/Republican_Party_(United_States)',
    :url_slug => 'republican-party'
party.id = 5
party.save

## Create ideologies
Ideology.create :name => 'American nationalism', :url => 'http://en.wikipedia.org/wiki/American_nationalism'
Ideology.create :name => 'Christian nationalism', :url => 'http://en.wikipedia.org/wiki/Christian_nationalism'
Ideology.create :name => 'Economic nationalism', :url => 'http://en.wikipedia.org/wiki/Economic_nationalism'
Ideology.create :name => 'National conservatism', :url => 'http://en.wikipedia.org/wiki/National_conservatism'
Ideology.create :name => 'Paleoconservatism', :url => 'http://en.wikipedia.org/wiki/Paleoconservatism'
Ideology.create :name => 'Religious conservatism', :url => 'http://en.wikipedia.org/wiki/Religious_conservatism'
Ideology.create :name => 'Social conservatism', :url => 'http://en.wikipedia.org/wiki/Social_conservatism'
Ideology.create :name => 'Protectionism', :url => 'http://en.wikipedia.org/wiki/Protectionism'
Ideology.create :name => 'American Liberalism', :url => 'http://en.wikipedia.org/wiki/Liberalism_in_the_United_States'
Ideology.create :name => 'Modern liberalism', :url => 'http://en.wikipedia.org/wiki/Social_liberalism'
Ideology.create :name => 'Third Way', :url => 'http://en.wikipedia.org/wiki/Third_Way_(Centrism)'
Ideology.create :name => 'Progressivism', :url => 'http://en.wikipedia.org/wiki/Progressivism_in_the_United_States'
Ideology.create :name => 'Green politics', :url => 'http://en.wikipedia.org/wiki/Green_politics'
Ideology.create :name => 'Social democracy', :url => 'http://en.wikipedia.org/wiki/Social_democracy'
Ideology.create :name => 'Grassroots democracy', :url => 'http://en.wikipedia.org/wiki/Grassroots_democracy'
Ideology.create :name => 'Populism', :url => 'http://en.wikipedia.org/wiki/Populism'
Ideology.create :name => 'Civil libertarianism', :url => 'http://en.wikipedia.org/wiki/Civil_libertarianism'
Ideology.create :name => 'Libertarianism', :url => 'http://en.wikipedia.org/wiki/Libertarianism'
Ideology.create :name => 'Classical liberalism', :url => 'http://en.wikipedia.org/wiki/Classical_liberalism'
Ideology.create :name => 'Civil liberties', :url => 'http://en.wikipedia.org/wiki/Civil_liberties'
Ideology.create :name => 'Minarchism', :url => 'http://en.wikipedia.org/wiki/Minarchism'
Ideology.create :name => 'Centrism', :url => 'http://en.wikipedia.org/wiki/Centrism'
Ideology.create :name => 'American Conservatism', :url => 'http://en.wikipedia.org/wiki/Conservatism_in_the_United_States'
Ideology.create :name => 'Fiscal conservatism', :url => 'http://en.wikipedia.org/wiki/Fiscal_conservatism'
Ideology.create :name => 'Libertarian conservatism', :url => 'http://en.wikipedia.org/wiki/Libertarian_conservatism'

## Create party ideologies

# Constitution Party
party = Party.find_by_official_name 'Constitution Party'
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'American nationalism' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Christian nationalism' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Economic nationalism' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'National conservatism' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Paleoconservatism' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Religious conservatism' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Social conservatism' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Protectionism' )

# Democratic Party
party = Party.find_by_official_name 'Democratic Party'
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'American Liberalism' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Modern liberalism' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Third Way' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Progressivism' )

# Green Party
party = Party.find_by_official_name 'Green Party'
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Green politics' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Social democracy' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Grassroots democracy' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Populism' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Progressivism' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Civil libertarianism' )

# Libertarian Party
party = Party.find_by_official_name 'Libertarian Party'
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Libertarianism' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Classical liberalism' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Civil liberties' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Minarchism' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Centrism' )

# Republican Party
party = Party.find_by_official_name 'Republican Party'
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'American Conservatism ' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Classical liberalism' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Fiscal conservatism' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Social conservatism' )
PartyIdeology.create :party => party, :ideology => Ideology.find_by_name( 'Libertarian conservatism' )

## Create mobile devices
mobile_device = MobileDevice.find_by_foursquare_name( 'foursquare for iPhone' )
if !mobile_device
  mobile_device = MobileDevice.new :foursquare_name => 'foursquare for iPhone', :display_name => 'iPhone', :eligible => true
  mobile_device.id = 1
  mobile_device.save
end

mobile_device = MobileDevice.find_by_foursquare_name( 'foursquare for Android' )
if !mobile_device
  mobile_device = MobileDevice.new :foursquare_name => 'foursquare for Android', :display_name => 'Android', :eligible => true
  mobile_device.id = 2
  mobile_device.save
end

mobile_device = MobileDevice.find_by_foursquare_name( 'foursquare for BlackBerry' )
if !mobile_device
  mobile_device = MobileDevice.new :foursquare_name => 'foursquare for BlackBerry', :display_name => 'BlackBerry', :eligible => true
  mobile_device.id = 3
  mobile_device.save
end

## Create countries
country = Country.find_by_name( 'United States' )
if !country
  country = Country.new :code => 'US', :name => 'United States'
  country.id = 1
  country.save
end

# Create states
country = Country.find_by_name( 'United States' )

state = State.new :name => 'Alabama', :abbrev => 'AL', :url_slug => 'alabama', :country => country, :electoral_college => 9
state.id = 1
state.save
state = State.new :name => 'Alaska', :abbrev => 'AK', :url_slug => 'alaska', :country => country, :electoral_college => 3
state.id = 2
state.save
state = State.new :name => 'Arizona', :abbrev => 'AZ', :url_slug => 'arizona', :country => country, :electoral_college => 10
state.id = 3
state.save
state = State.new :name => 'Arkansas', :abbrev => 'AR', :url_slug => 'arkansas', :country => country, :electoral_college => 6
state.id = 4
state.save
state = State.new :name => 'California', :abbrev => 'CA', :url_slug => 'california', :country => country, :electoral_college => 55
state.id = 5
state.save
state = State.new :name => 'Colorado', :abbrev => 'CO', :url_slug => 'colorado', :country => country, :electoral_college => 9
state.id = 6
state.save
state = State.new :name => 'Connecticut', :abbrev => 'CT', :url_slug => 'connecticut', :country => country, :electoral_college => 7
state.id = 7
state.save
state = State.new :name => 'Delaware', :abbrev => 'DE', :url_slug => 'delaware', :country => country, :electoral_college => 3
state.id = 8
state.save
state = State.new :name => 'District of Columbia', :abbrev => 'DC', :url_slug => 'district-of-columbia', :country => country, :electoral_college => 3
state.id = 9
state.save
state = State.new :name => 'Florida', :abbrev => 'FL', :url_slug => 'florida', :country => country, :electoral_college => 27
state.id = 10
state.save
state = State.new :name => 'Georgia', :abbrev => 'GA', :url_slug => 'georgia', :country => country, :electoral_college => 15
state.id = 11
state.save
state = State.new :name => 'Hawaii', :abbrev => 'HI', :url_slug => 'hawaii', :country => country, :electoral_college => 4
state.id = 12
state.save
state = State.new :name => 'Idaho', :abbrev => 'ID', :url_slug => 'idaho', :country => country, :electoral_college => 4
state.id = 13
state.save
state = State.new :name => 'Illinois', :abbrev => 'IL', :url_slug => 'illinois', :country => country, :electoral_college => 21
state.id = 14
state.save
state = State.new :name => 'Indiana', :abbrev => 'IN', :url_slug => 'indiana', :country => country, :electoral_college => 11
state.id = 15
state.save
state = State.new :name => 'Iowa', :abbrev => 'IA', :url_slug => 'iowa', :country => country, :electoral_college => 7
state.id = 16
state.save
state = State.new :name => 'Kansas', :abbrev => 'KS', :url_slug => 'kansas', :country => country, :electoral_college => 6
state.id = 17
state.save
state = State.new :name => 'Kentucky', :abbrev => 'KY', :url_slug => 'kentucky', :country => country, :electoral_college => 8
state.id = 18
state.save
state = State.new :name => 'Louisiana', :abbrev => 'LA', :url_slug => 'louisiana', :country => country, :electoral_college => 9
state.id = 19
state.save
state = State.new :name => 'Maine', :abbrev => 'ME', :url_slug => 'maine', :country => country, :electoral_college => 4
state.id = 20
state.save
state = State.new :name => 'Maryland', :abbrev => 'MD', :url_slug => 'maryland', :country => country, :electoral_college => 10
state.id = 21
state.save
state = State.new :name => 'Massachusetts', :abbrev => 'MA', :url_slug => 'massachusetts', :country => country, :electoral_college => 12
state.id = 22
state.save
state = State.new :name => 'Michigan', :abbrev => 'MI', :url_slug => 'michigan', :country => country, :electoral_college => 17
state.id = 23
state.save
state = State.new :name => 'Minnesota', :abbrev => 'MN', :url_slug => 'minnesota', :country => country, :electoral_college => 10
state.id = 24
state.save
state = State.new :name => 'Mississippi', :abbrev => 'MS', :url_slug => 'mississippi', :country => country, :electoral_college => 6
state.id = 25
state.save
state = State.new :name => 'Missouri', :abbrev => 'MO', :url_slug => 'missouri', :country => country, :electoral_college => 11
state.id = 26
state.save
state = State.new :name => 'Montana', :abbrev => 'MT', :url_slug => 'montana', :country => country, :electoral_college => 3
state.id = 27
state.save
state = State.new :name => 'Nebraska', :abbrev => 'NE', :url_slug => 'nebraska', :country => country, :electoral_college => 5
state.id = 28
state.save
state = State.new :name => 'Nevada', :abbrev => 'NV', :url_slug => 'nevada', :country => country, :electoral_college => 5
state.id = 29
state.save
state = State.new :name => 'New Hampshire', :abbrev => 'NH', :url_slug => 'new-hampshire', :country => country, :electoral_college => 4
state.id = 30
state.save
state = State.new :name => 'New Jersey', :abbrev => 'NJ', :url_slug => 'new-jersey', :country => country, :electoral_college => 15
state.id = 31
state.save
state = State.new :name => 'New Mexico', :abbrev => 'NM', :url_slug => 'new-mexico', :country => country, :electoral_college => 5
state.id = 32
state.save
state = State.new :name => 'New York', :abbrev => 'NY', :url_slug => 'new-york', :country => country, :electoral_college => 31
state.id = 33
state.save
state = State.new :name => 'North Carolina', :abbrev => 'NC', :url_slug => 'north-carolina', :country => country, :electoral_college => 15
state.id = 34
state.save
state = State.new :name => 'North Dakota', :abbrev => 'ND', :url_slug => 'north-dakota', :country => country, :electoral_college => 3
state.id = 35
state.save
state = State.new :name => 'Ohio', :abbrev => 'OH', :url_slug => 'ohio', :country => country, :electoral_college => 20
state.id = 36
state.save
state = State.new :name => 'Oklahoma', :abbrev => 'OK', :url_slug => 'oklahoma', :country => country, :electoral_college => 7
state.id = 37
state.save
state = State.new :name => 'Oregon', :abbrev => 'OR', :url_slug => 'oregon', :country => country, :electoral_college => 7
state.id = 38
state.save
state = State.new :name => 'Pennsylvania', :abbrev => 'PA', :url_slug => 'pennsylvania', :country => country, :electoral_college => 21
state.id = 39
state.save
state = State.new :name => 'Rhode Island', :abbrev => 'RI', :url_slug => 'rhode-island', :country => country, :electoral_college => 4
state.id = 40
state.save
state = State.new :name => 'South Carolina', :abbrev => 'SC', :url_slug => 'south-carolina', :country => country, :electoral_college => 8
state.id = 41
state.save
state = State.new :name => 'South Dakota', :abbrev => 'SD', :url_slug => 'south-dakota', :country => country, :electoral_college => 3
state.id = 42
state.save
state = State.new :name => 'Tennessee', :abbrev => 'TN', :url_slug => 'tennessee', :country => country, :electoral_college => 11
state.id = 43
state.save
state = State.new :name => 'Texas', :abbrev => 'TX', :url_slug => 'texas', :country => country, :electoral_college => 34
state.id = 44
state.save
state = State.new :name => 'Utah', :abbrev => 'UT', :url_slug => 'utah', :country => country, :electoral_college => 5
state.id = 45
state.save
state = State.new :name => 'Vermont', :abbrev => 'VT', :url_slug => 'vermont', :country => country, :electoral_college => 3
state.id = 46
state.save
state = State.new :name => 'Virginia', :abbrev => 'VA', :url_slug => 'virginia', :country => country, :electoral_college => 13
state.id = 47
state.save
state = State.new :name => 'Washington', :abbrev => 'WA', :url_slug => 'washington', :country => country, :electoral_college => 11
state.id = 48
state.save
state = State.new :name => 'West Virginia', :abbrev => 'WV', :url_slug => 'west-virginia', :country => country, :electoral_college => 5
state.id = 49
state.save
state = State.new :name => 'Wisconsin', :abbrev => 'WI', :url_slug => 'wisconsin', :country => country, :electoral_college => 10
state.id = 50
state.save
state = State.new :name => 'Wyoming', :abbrev => 'WY', :url_slug => 'wyoming', :country => country, :electoral_college => 3
state.id = 51
state.save

## Initialize zip codes

## Create Chicago
illinois = State.find_by_name( "Illinois" )
chicago = City.find_by_name_and_state_id( "Chicago", illinois.id )
if !chicago
  chicago = City.new( :name => "Chicago", :state => illinois )
  chicago.save
end

## Create NYC
new_york = State.find_by_name( "New York" )
nyc = City.find_by_name_and_state_id( "New York", new_york.id )
unless nyc
  nyc = City.new( :name => "New York", :state => new_york )
  nyc.save
end

## Initialize NYC zip codes
nyc_zips = ["10451","10452","10453","10454","10455","10456","10457","10458","10459","10460","10461","10462","10463","10464","10465","10466","10467","10468","10469","10470","10471","10472","10473","10474","10475","11201","11203","11204","11205","11206","11207","11208","11209","11210","11211","11212","11213","11214","11215","11216","11217","11218","11219","11220","11221","11222","11223","11224","11225","11226","11228","11229","11230","11231","11232","11233","11234","11235","11236","11237","11238","11239","11241","11242","11243","11249","11252","11256","10001","10002","10003","10004","10005","10006","10007","10009","10010","10011","10012","10013","10014","10015","10016","10017","10018","10019","10020","10021","10022","10023","10024","10025","10026","10027","10028","10029","10030","10031","10032","10033","10034","10035","10036","10037","10038","10039","10040","10041","10044","10045","10048","10055","10060","10069","10090","10095","10098","10099","10103","10104","10105","10106","10107","10110","10111","10112","10115","10118","10119","10120","10121","10122","10123","10128","10151","10152","10153","10154","10155","10158","10161","10162","10165","10166","10167","10168","10169","10170","10171","10172","10173","10174","10175","10176","10177","10178","10199","10270","10271","10278","10279","10280","10281","10282","11101","11102","11103","11004","11104","11105","11106","11109","11351","11354","11355","11356","11357","11358","11359","11360","11361","11362","11363","11364","11365","11366","11367","11368","11369","11370","11371","11372","11373","11374","11375","11377","11378","11379","11385","11411","11412","11413","11414","11415","11416","11417","11418","11419","11420","11421","11422","11423","11426","11427","11428","11429","11430","11432","11433","11434","11435","11436","11691","11692","11693","11694","11697","10301","10302","10303","10304","10305","10306","10307","10308","10309","10310","10311","10312","10314"]

## Create NYC zip codes
nyc_zips.each do |nyc_zip|
  zip = ZipCode.find_by_name( nyc_zip )
  if zip
    zip.update_attribute( :city, nyc )
  else
    zip = ZipCode.new( :name => nyc_zip, :city => nyc )
    zip.save
  end
end

## Create DC
state = State.find_by_name( "District of Columbia" )
dc = City.find_by_name_and_state_id( "Washington", state.id )
if !dc
  dc = City.new( :name => "Washington", :state => state )
  dc.save
end

## Initialize DC zip codes
dc_zips = ["20001","20002","20003","20004","20005","20006","20007","20008","20009","20010","20011","20012","20013","20015","20016","20017","20018","20019","20020","20024","20026","20029","20030","20032","20033","20035","20036","20037","20038","20039","20040","20041","20042","20043","20044","20045","20046","20047","20049","20050","20051","20052","20053","20055","20056","20057","20058","20059","20060","20061","20062","20063","20064","20065","20066","20067","20068","20069","20070","20071","20073","20074","20075","20076","20077","20078","20080","20081","20082","20088","20090","20091","20097","20098","20099","20201","20202","20203","20204","20206","20207","20208","20210","20211","20212","20213","20214","20215","20216","20217","20218","20219","20220","20221","20222","20223","20224","20226","20227","20228","20229","20230","20231","20232","20233","20235","20238","20239","20240","20241","20242","20244","20245","20250","20251","20254","20260","20261","20262","20265","20266","20268","20270","20277","20289","20299","20301","20303","20306","20307","20310","20314","20315","20317","20318","20319","20330","20332","20336","20337","20338","20340","20350","20370","20372","20373","20374","20375","20380","20388","20389","20390","20391","20392","20393","20394","20395","20398","20401","20402","20403","20404","20405","20406","20407","20408","20409","20410","20411","20412","20413","20414","20415","20416","20418","20419","20420","20421","20422","20423","20424","20425","20426","20427","20428","20429","20431","20433","20434","20435","20436","20437","20439","20440","20441","20442","20444","20447","20451","20453","20456","20460","20463","20468","20469","20470","20472","20501","20502","20503","20504","20505","20506","20507","20508","20510","20515","20520","20521","20522","20523","20524","20525","20526","20527","20530","20531","20532","20533","20534","20535","20536","20537","20538","20539","20540","20541","20542","20543","20544","20546","20547","20548","20549","20550","20551","20552","20553","20554","20555","20557","20558","20559","20560","20565","20566","20570","20571","20572","20573","20575","20576","20577","20578","20579","20580","20581","20585","20586","20590","20591","20593","20594","20597","20599"]

## Create DC zip codes
dc_zips.each do |dc_zip|
  zip = ZipCode.find_by_name( dc_zip )
  if zip
    zip.update_attribute( :city, dc )
  else
    zip = ZipCode.new( :name => dc_zip, :city => dc )
    zip.save
  end
end