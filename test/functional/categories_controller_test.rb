require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  test "should get top_level_index" do
    get :top_level_index
    assert_response :success
  end

  test "should get top_level_show" do
    get :top_level_show
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

end
