require 'custom_bitly'

class Company < ActiveRecord::Base

  belongs_to :parent, :class_name=> 'Company', :foreign_key => 'parent_id'
	has_many :company_names
	has_many :friend_checkins
	has_many :points
	has_many :venues
	has_one :party_contribution
	
	named_scope :active, :conditions => ["url_slug is not null"], :order => 'short_name'
	
	def self.identify( venue_name, twitter_handle=nil )
    ## Find by venue name
    company_name = CompanyName.find_by_name( sanitize( venue_name ) ) if venue_name
    if company_name
      if company_name.company.url_slug
        return company_name.company
      elsif company_name.company.parent
        return company_name.company.parent
      end
      #return company_name.company.parent ? company_name.company.parent : company_name.company
    end
    ## Find partial
    #company_name = CompanyName.find( :first, :conditions =>  (sanitize(venue_name) ? { :name => sanitize(venue_name).split} : []) )
    #if company_name
    #  return company_name.company.parent ? company_name.company.parent : company_name.company
    #end
	  nil
	end
	
	def self.sanitize( str )
	  str.gsub(/[^0-9A-Za-z' ''&'-]/, '')
	end
	
	def children( url_slug_required=false )
	  if url_slug_required
	    Company.find( :all, :conditions => ["parent_id = ? and url_slug is not null", self.id], :order => 'short_name' )
	  else
	    Company.find_all_by_parent_id( self.id )
	  end
	end

	def get_parents( parent_companies=nil )
	  if !parent_companies
      parent_companies = []
    end
    if self.parent
      parent_companies = self.parent.get_parents( parent_companies )
      parent_companies << self.parent
    end
    parent_companies
	end
	
	def get_children( child_companies=nil )
	  if !child_companies
	    child_companies = []
	  end
	  self.children.each do |child_company|
	    child_companies = child_company.get_children( child_companies )
	    child_companies << child_company
	  end
	  child_companies
	end
	
	## Calculate aggregate party breakdown data
	def party_breakdown
	  ## Get all parent and child companies
	  companies = [self.get_parents, self.get_children].flatten
	  ## Initialize party contibution data
	  dem_amount = rep_amount = other_amount = 0
	  ## Start with company's party contribution data
	  if self.party_contribution
	    dem_amount = self.party_contribution.dem_amount
	    rep_amount = self.party_contribution.rep_amount
	    other_amount = self.party_contribution.other_amount
	  end
	  ## Add all parent and child company party contribution data
	  companies.each do |company|
	    if company.party_contribution
	      dem_amount += company.party_contribution.dem_amount
	      rep_amount += company.party_contribution.rep_amount
	      other_amount += company.party_contribution.other_amount
	    end
	  end
    ## Create temporary Party Contribution object
    PartyContribution.new( :company => self, :dem_amount => dem_amount, :rep_amount => rep_amount, :other_amount => other_amount )
	end
	
	def is_democratic?
	  pc = party_breakdown
    return ( ( pc.dem_amount > pc.rep_amount ) and ( pc.dem_amount > pc.other_amount ) )
	end
	
	def is_republican?
	  pc = party_breakdown
    return ( (pc.rep_amount > pc.dem_amount ) and ( pc.rep_amount > pc.other_amount ) )
	end
	
	def is_partisan?
	  return ( is_democratic? or is_republican? )
	end
	
	def party_order
	  output = []
	  pc = party_breakdown
	  if is_democratic?
	    output << 'dem'
	    if pc.rep_amount > pc.other_amount
	      output << 'rep'
	      output << 'other'
	    else
	      output << 'other'
	      output << 'rep'
	    end
	  elsif is_republican?
	    output << 'rep'
	    if pc.dem_amount > pc.other_amount
	      output << 'dem'
	      output << 'other'
	    else
	      output << 'other'
	      output << 'dem'
	    end
	  else
	    output << 'other'
	    if pc.dem_amount > pc.rep_amount
	      output << 'dem'
	      output << 'rep'
	    else
	    	output << 'rep'
	      output << 'dem'
	    end
	  end
	  output
	end
	
	def is_strongly_democratic?
	  pc = party_breakdown
	  return pc.dem_percent > 0.665
	end
	
	def is_strongly_republican?
	  pc = party_breakdown
	  return pc.rep_percent > 0.665
	end
	
	def url
	  "#{ SITE_URL }/companies/#{ self.url_slug }"
	end
	
	def score
	  if self.is_strongly_democratic?
	    return 2
	  elsif self.is_democratic?
	    return 1
	  elsif self.is_strongly_republican?
	    return 2
	  elsif self.is_republican?
	    return 1
	  end
	  return 0  
	end
	
	def reply_text
	  prefix = breakdown = suffix = ''
	  pc = party_breakdown
	  formatted_amount = ActionController::Base.helpers.number_to_currency( pc.total_amount, :precision => 0 )
	  #prefix = "#{ self.short_name } has given #{ formatted_amount } in campaign contributions"
	  prefix = "#{ self.short_name } gives most of their campaign contributions to"
	  if is_democratic?
	    #breakdown = " (#{ sprintf( "%.0f", pc.dem_percent * 100 ) }% Dem, #{ sprintf( "%.0f", pc.rep_percent * 100 ) }% Rep)."
	    breakdown = " Democrats (#{ sprintf( "%.0f", pc.dem_percent * 100 ) }% Dem, #{ sprintf( "%.0f", pc.rep_percent * 100 ) }% Rep)."
	    suffix = " By going to #{ self.short_name }, you're supporting the Democrats."
	  elsif is_republican?
	    #breakdown = " (#{ sprintf( "%.0f", pc.rep_percent * 100 ) }% Rep, #{ sprintf( "%.0f", pc.dem_percent * 100 ) }% Dem)."
	    breakdown = " Republicans (#{ sprintf( "%.0f", pc.rep_percent * 100 ) }% Rep, #{ sprintf( "%.0f", pc.dem_percent * 100 ) }% Dem)."
	    suffix = " By going to #{ self.short_name }, you're supporting the Republicans."
	  else
	    return nil
	  end
	  output = "#{ prefix }#{ breakdown }#{ suffix }"
	  if output.length <= 200
	    return output
	  else
	    return "#{ prefix }#{ breakdown }"
	  end
	end
	
	def add_post_text
	  prefix = breakdown = suffix = ''
	  pc = party_breakdown
	  formatted_amount = ActionController::Base.helpers.number_to_currency( pc.total_amount, :precision => 0 )
	  #prefix = "#{ self.short_name } has given #{ formatted_amount } in campaign contributions"
	  prefix = "#{ self.short_name } gives most of their campaign contributions to"
	  if is_democratic?
	    #breakdown = " (#{ sprintf( "%.0f", pc.dem_percent * 100 ) }% Dem, #{ sprintf( "%.0f", pc.rep_percent * 100 ) }% Rep)."
	    breakdown = " Democrats (#{ sprintf( "%.0f", pc.dem_percent * 100 ) }% Dem, #{ sprintf( "%.0f", pc.rep_percent * 100 ) }% Rep)."
	    #suffix = " Checking-in to #{ self.short_name } will help the Democrats achieve victory this November."
	    suffix = ""
	  elsif is_republican?
	    #breakdown = " (#{ sprintf( "%.0f", pc.rep_percent * 100 ) }% Rep, #{ sprintf( "%.0f", pc.dem_percent * 100 ) }% Dem)."
	    breakdown = " Republicans (#{ sprintf( "%.0f", pc.rep_percent * 100 ) }% Rep, #{ sprintf( "%.0f", pc.dem_percent * 100 ) }% Dem)."
	    #suffix = " Checking-in to #{ self.short_name } will help the Republicans achieve victory this November."
	    suffix = ""
	  else
	    return nil
	  end
	  output = "#{ prefix }#{ breakdown }#{ suffix } #GeoPollster"
	  if output.length <= 200
	    return output
	  else
	    output =  "#{ prefix }#{ breakdown }#{ suffix }"
	    if output.length <= 200
	      return output
	    else
	      output = "#{ prefix }#{ breakdown }"
	      if output.length <= 200
	        return output
	      end
      end
	  end
	end
	
	def comment_text
	  return nil if !reply_text
	  short_url = CustomBitly.shorten( url )
	  output = "#{ reply_text } #{ short_url } #GeoPollster"
	  if output.length <= 200
	    return output
	  else
	    output = "#{ reply_text } #{ short_url }"
	    if output.length <= 200
	      return output
	    else
	      return reply_text
	    end
	  end
	end
	
	def tweet
	  prefix = nil
	  if is_democratic?
	    prefix = "I'm at #{ short_name }, which gives most of their campaign contributions to Democrats #{ CustomBitly.shorten( url ) }"
	    party_tag = "#dems"
	  elsif is_republican?
	    prefix = "I'm at #{ short_name }, which gives most of their campaign contributions to Republicans #{ CustomBitly.shorten( url ) }"
	    party_tag = "#gop"
	  end
	  return nil if !prefix
	  output = "#{ prefix } #GeoPollster #{ party_tag } #campaignfinance"
	  if output.length <= 140
	    return output
	  else
      output = "#{ prefix } #GeoPollster #{ party_tag }"
	    if output.length <= 140
	      return output
	    else
	      output = "#{ prefix } #GeoPollster"
	      if output.length <= 140
	        return output
	      else
	        output = "#{ prefix }"
	        if output.length <= 140
	          return output
	        end
	      end
	    end
	  end
	  nil
	  #pc = party_breakdown
	  #formatted_amount = ActionController::Base.helpers.number_to_currency( pc.total_amount, :precision => 0 )
	  #if is_democratic?
	  #  str = "#{ self.short_name } gave #{ formatted_amount } to politicians in 2012: #{ sprintf( "%.0f", pc.dem_percent * 100 ) }% to #{ TWITTER[:DEMOCRATS] }, #{ sprintf( "%.0f", pc.rep_percent * 100 ) }% to #{ TWITTER[:REPUBLICANS] }"
	  #elsif is_republican?
	  #  str = "#{ self.short_name } gave #{ formatted_amount } to politicians in 2012: #{ sprintf( "%.0f", pc.rep_percent * 100 ) }% to #{ TWITTER[:REPUBLICANS] }, #{ sprintf( "%.0f", pc.dem_percent * 100 ) }% to #{ TWITTER[:DEMOCRATS] }"
	  #end
    ##Tags	  
	  #ActionController::Base.helpers.number_to_currency(amount, :precision => 0)
	  #dems
	  #gop
	  #geopollster
	  #opengov
	  #campaignfinance
	end

end
