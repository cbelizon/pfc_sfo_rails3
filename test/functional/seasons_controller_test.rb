require 'test_helper'

class SeasonsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:seasons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create season" do
    assert_difference('Season.count') do
      post :create, :season => { }
    end

    assert_redirected_to season_path(assigns(:season))
  end

  test "should show season" do
    get :show, :id => seasons(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => seasons(:one).to_param
    assert_response :success
  end

  test "should update season" do
    put :update, :id => seasons(:one).to_param, :season => { }
    assert_redirected_to season_path(assigns(:season))
  end

  test "should destroy season" do
    assert_difference('Season.count', -1) do
      delete :destroy, :id => seasons(:one).to_param
    end

    assert_redirected_to seasons_path
  end
end
