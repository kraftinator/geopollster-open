class VoteCount < ActiveRecord::Base

  belongs_to :object, :polymorphic => true
  belongs_to :party
  
  def self.cached_polling( object )
    self.find( :all,
        :conditions => ["object_type = ? and object_id = ? and total > 0", object.class.name, object.id],
        :select => 'party_id, sum(vote_counts.total) as total',
        :group => 'party_id',
        :order => 'total desc'
    )
  end
  
  def self.cached_polling_all( object )
    self.find( :all,
        :conditions => ["object_type = ? and total > 0", object],
        :select => 'object_id, party_id, sum(vote_counts.total) as total',
        :group => 'object_id, party_id',
        :order => 'object_id, total desc'
    )
  end
  
end
