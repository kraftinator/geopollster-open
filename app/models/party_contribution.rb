class PartyContribution < ActiveRecord::Base

	belongs_to :company
	
	def total_amount
	  self.dem_amount + self.rep_amount + self.other_amount
	end
	
	def dem_percent
	  self.dem_amount / self.total_amount
	end
	
	def rep_percent
	  self.rep_amount / self.total_amount
	end
	
	def other_percent
	  self.other_amount / self.total_amount
	end
	
end
