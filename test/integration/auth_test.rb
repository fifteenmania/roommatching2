require 'test_helper'

class AuthTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "can see the welcome page" do
    get "/"
  end
end
