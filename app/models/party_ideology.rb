class PartyIdeology < ActiveRecord::Base
  belongs_to :party
  belongs_to :ideology
end
