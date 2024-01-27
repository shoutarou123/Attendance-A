require "test_helper"

class BasePointsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get base_points_index_url
    assert_response :success
  end

  test "should get new" do
    get base_points_new_url
    assert_response :success
  end
end
