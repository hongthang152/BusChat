require 'test_helper'

class DirectionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get direction_index_url
    assert_response :success
  end

end
