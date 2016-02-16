class Point < ActiveRecord::Base

  belongs_to :dem_company, :class_name=> 'Company', :foreign_key => 'dem_company_id'
  belongs_to :rep_company, :class_name=> 'Company', :foreign_key => 'rep_company_id'
  belongs_to :user
  
  named_scope :eligible_dems, :include => [:user], :conditions => ['users.active is true and users.public_profile is true and users.deleted_at is null and dem_total > 0'], :order => 'dem_total desc', :limit => 100
  named_scope :eligible_reps, :include => [:user], :conditions => ['users.active is true and users.public_profile is true and users.deleted_at is null and rep_total > 0'], :order => 'rep_total desc', :limit => 100
  
  def calculate
    dem_count = rep_count = 0
    top_dem = []
    top_rep = []
    self.user.checkins.each do |checkin|
      next unless checkin.venue.company
      company = checkin.venue.company
      if company.is_strongly_democratic?
        dem_count += 2
        top_dem << company.id
        top_dem << company.id
      elsif company.is_democratic?
        dem_count += 1
        top_dem << company.id
      elsif company.is_strongly_republican?
        rep_count += 2
        top_rep << company.id
        top_rep << company.id
      elsif company.is_republican?
        rep_count += 1
        top_rep << company.id
      end
    end
    dem_company_id = top_dem.mode if top_dem.any?
    rep_company_id = top_rep.mode if top_rep.any?
    #self.update_attributes( :dem_total => dem_count, :rep_total => rep_count, :dem_company_id => top_dem.mode, :rep_company_id => top_rep.mode )
    self.update_attributes( :dem_total => dem_count, :rep_total => rep_count, :dem_company_id => dem_company_id, :rep_company_id => rep_company_id )
  end
  
  def self.calculate( checkins )
    dem_count = rep_count = 0
    checkins.each do |checkin|
      company = checkin.get_company
      next unless company
      if company.is_strongly_democratic?
        dem_count += 2
      elsif company.is_democratic?
        dem_count += 1
      elsif company.is_strongly_republican?
        rep_count += 2
      elsif company.is_republican?
        rep_count += 1
      end
    end
    Point.new( :dem_total => dem_count, :rep_total => rep_count )
  end
  
  def is_democratic?
    self.dem_total > self.rep_total
  end
  
  def is_republican?
    self.rep_total > self.dem_total
  end
  
  def is_tied?
    self.dem_total == self.rep_total
  end
  
  def total
    self.dem_total + self.rep_total
  end
  
  def has_points?
    self.total > 0
  end
  
  def dem_percent
    self.dem_total.to_f / self.total.to_f
  end
  
  def rep_percent
    self.rep_total.to_f / self.total.to_f
  end
  
end

class Array
    def mode
      group_by{|i| i}.max{|x,y| x[1].length <=> y[1].length}[0]
    end
  end