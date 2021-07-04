require "test_helper"

class RecycleControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get recycle_index_url
    assert_response :success
  end
end
