require 'test_helper'

class RoomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @room = rooms(:one)
  end

  test "should get index" do
    get rooms_url, as: :json
    assert_response :success
  end

  test "should create room" do
    assert_difference('Room.count') do
      post rooms_url, params: { room: { home_id: @room.home_id, receiver_id: @room.receiver_id, room_name: @room.room_name } }, as: :json
    end

    assert_response 201
  end

  test "should show room" do
    get room_url(@room), as: :json
    assert_response :success
  end

  test "should update room" do
    patch room_url(@room), params: { room: { home_id: @room.home_id, receiver_id: @room.receiver_id, room_name: @room.room_name } }, as: :json
    assert_response 200
  end

  test "should destroy room" do
    assert_difference('Room.count', -1) do
      delete room_url(@room), as: :json
    end

    assert_response 204
  end
end
