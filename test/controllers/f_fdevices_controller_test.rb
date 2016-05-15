require 'test_helper'

class FFdevicesControllerTest < ActionController::TestCase
  setup do
    @f_fdevice = f_fdevices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:f_fdevices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create f_fdevice" do
    assert_difference('FFdevice.count') do
      post :create, f_fdevice: { name: @f_fdevice.name, organization_id: @f_fdevice.organization_id, user_id: @f_fdevice.user_id }
    end

    assert_redirected_to f_fdevice_path(assigns(:f_fdevice))
  end

  test "should show f_fdevice" do
    get :show, id: @f_fdevice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @f_fdevice
    assert_response :success
  end

  test "should update f_fdevice" do
    patch :update, id: @f_fdevice, f_fdevice: { name: @f_fdevice.name, organization_id: @f_fdevice.organization_id, user_id: @f_fdevice.user_id }
    assert_redirected_to f_fdevice_path(assigns(:f_fdevice))
  end

  test "should destroy f_fdevice" do
    assert_difference('FFdevice.count', -1) do
      delete :destroy, id: @f_fdevice
    end

    assert_redirected_to f_fdevices_path
  end
end
