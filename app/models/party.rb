class Party < ActiveRecord::Base

  has_many :categories
  has_many :cities
  has_many :countries
  has_many :states
  has_many :party_ideologies
  has_many :ideologies, :through => :party_ideologies, :order => :name
  has_many :users
  has_many :venues
  has_many :vote_counts
  has_many :votes
  
  def top_categories( max )
    VoteCount.find( :all,
        :conditions => ["object_type = 'Category' and party_id = ? and total > 0", self.id],
        :select => 'object_id as category_id, sum(vote_counts.total) as total',
        :group => 'object_id',
        :order => 'total desc',
        :limit => max )
  end
  
  def total_category_votes
    VoteCount.sum( 'total', :conditions => ["object_type = 'Category' and party_id = ?", self.id] )
  end

end
