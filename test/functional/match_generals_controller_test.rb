require 'test_helper'

class MatchGeneralsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:match_generals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create match_general" do
    assert_difference('MatchGeneral.count') do
      post :create, :match_general => { }
    end

    assert_redirected_to match_general_path(assigns(:match_general))
  end

  test "should show match_general" do
    get :show, :id => match_generals(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => match_generals(:one).to_param
    assert_response :success
  end

  test "should update match_general" do
    put :update, :id => match_generals(:one).to_param, :match_general => { }
    assert_redirected_to match_general_path(assigns(:match_general))
  end

  test "should destroy match_general" do
    assert_difference('MatchGeneral.count', -1) do
      delete :destroy, :id => match_generals(:one).to_param
    end

    assert_redirected_to match_generals_path
  end
end
