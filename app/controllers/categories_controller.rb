class CategoriesController < ApplicationController

  def index
    @title = 'Categories'
    @categories = Category.top_level
  end

  def top_level
    @category = Category.find_by_url_slug( params[:url_slug] )
    @title = @category.display_name
  end

  def show
    @category = Category.find_by_url_slug( params[:url_slug] )
    @title = @category.display_name
    @power_changes = PowerChange.recent( 10, @category )
    @category_results = @category.polling
    @parties = Party.find(:all)
  end

end
