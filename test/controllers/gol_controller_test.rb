require "test_helper"

class GolControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get gol_index_url
    assert_response :success
  end
end
