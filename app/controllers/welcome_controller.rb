class WelcomeController < ApplicationController

	def index
		@title = 'Empower Your Smartphone'
		@notice = params[:notice] if params[:notice]
		@states = State.find(:all, :select => "abbrev, party_id, id")
		@state_results = State.polling_all
		@country_id = Country.find(:first)
		@country_results = @country_id.polling
		@parties = Party.find(:all)
		men = Gender.find(:first, :conditions => ["name = ?", "Male"])
		women = Gender.find(:first, :conditions => ["name = ?", "Female"])
		@male_results = men.polling
		@female_results = women.polling
		android = MobileDevice.find(:first, :conditions => ["foursquare_name = ?", "foursquare for Android"])
		iphone = MobileDevice.find(:first, :conditions => ["foursquare_name = ?", "foursquare for iPhone"])
		blackberry = MobileDevice.find(:first, :conditions => ["foursquare_name = ?", "foursquare for BlackBerry"])
		@android_results = android.polling
		@iphone_results = iphone.polling
		@blackberry_results = blackberry.polling
		#@electoral_results = State.electoral_college_polling
		#@electoral_results.sort! { |a,b| b.total <=> a.total }
		for s in @states
			s.party_id = 0 if !s.party_id
		end
	end

	def about
		@title = 'About'
	end
	
	def faq
		@title = 'FAQ'
	end

	def contact
		@title = 'Contact'
	end

	def press
		@title = 'Press'
	end

	def privacy
		@title = 'Privacy Policy'
	end

	def terms
		@title = 'Terms of Service'
	end
	
	def team
		@title = 'Our Team'
	end
	
end
