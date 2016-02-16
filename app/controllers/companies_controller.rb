class CompaniesController < ApplicationController

  before_filter :load_company, :except => [:index]

  def index
    @title = 'Companies'
    @companies = Company.active
  end

  def show
    @title = "#{ @company.short_name }"
  end

  private
  
  def load_company
    @company = Company.find_by_url_slug( params[:url_slug] )
  end

end
