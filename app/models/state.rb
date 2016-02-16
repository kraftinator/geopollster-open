class State < ActiveRecord::Base

	belongs_to :country
	belongs_to :party
	has_many :cities
	
	default_scope :order => 'name asc'
	
	def polling( cache=true )
		if cache
			VoteCount.cached_polling( self )
		else
			Vote.polling( self )
		end
	end
	
	def self.polling_all
		VoteCount.cached_polling_all( self )
	end
	
	def self.electoral_college_polling
		State.find( :all,
			:conditions => ["party_id IS NOT NULL"],
			:select => 'party_id, sum(electoral_college) as total',
			:group => 'party_id',
			:order => 'total desc')
	end
	
end
