require 'test_helper'

class UserHomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_home = user_homes(:one)
  end

  test "should get index" do
    get user_homes_url, as: :json
    assert_response :success
  end

  test "should create user_home" do
    assert_difference('UserHome.count') do
      post user_homes_url, params: { user_home: { home_id: @user_home.home_id, role: @user_home.role, user_id: @user_home.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show user_home" do
    get user_home_url(@user_home), as: :json
    assert_response :success
  end

  test "should update user_home" do
    patch user_home_url(@user_home), params: { user_home: { home_id: @user_home.home_id, role: @user_home.role, user_id: @user_home.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy user_home" do
    assert_difference('UserHome.count', -1) do
      delete user_home_url(@user_home), as: :json
    end

    assert_response 204
  end
end
