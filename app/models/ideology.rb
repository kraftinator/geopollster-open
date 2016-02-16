class Ideology < ActiveRecord::Base

  has_many :party_ideologies
  has_many :parties, :through => :party_ideologies
  
  validates_uniqueness_of :name, :case_sensitive => false
  validates_uniqueness_of :url, :case_sensitive => false
  
end
