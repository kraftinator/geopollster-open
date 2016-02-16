class FriendCheckin < ActiveRecord::Base

  belongs_to :company
  belongs_to :user
  belongs_to :venue
  
  def get_company
    return self.company if self.company
    return self.venue.company if self.venue and self.venue.company
    nil
  end
  
end
