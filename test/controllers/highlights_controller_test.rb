require "test_helper"

class HighlightsControllerTest < ActionDispatch::IntegrationTest
  test "should get scaffold" do
    get highlights_scaffold_url
    assert_response :success
  end
end
