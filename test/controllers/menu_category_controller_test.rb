require "test_helper"

class MenuCategoryControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get menu_category_index_url
    assert_response :success
  end
end
