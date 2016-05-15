require 'test_helper'

class DeviceHealthsControllerTest < ActionController::TestCase
  setup do
    @device_health = device_healths(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:device_healths)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create device_health" do
    assert_difference('DeviceHealth.count') do
      post :create, device_health: { available_mobile_data: @device_health.available_mobile_data, available_storage: @device_health.available_storage, current_battery_charge: @device_health.current_battery_charge, f_fdevice_id: @device_health.f_fdevice_id, health: @device_health.health, network_signal: @device_health.network_signal, user_id: @device_health.user_id }
    end

    assert_redirected_to device_health_path(assigns(:device_health))
  end

  test "should show device_health" do
    get :show, id: @device_health
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @device_health
    assert_response :success
  end

  test "should update device_health" do
    patch :update, id: @device_health, device_health: { available_mobile_data: @device_health.available_mobile_data, available_storage: @device_health.available_storage, current_battery_charge: @device_health.current_battery_charge, f_fdevice_id: @device_health.f_fdevice_id, health: @device_health.health, network_signal: @device_health.network_signal, user_id: @device_health.user_id }
    assert_redirected_to device_health_path(assigns(:device_health))
  end

  test "should destroy device_health" do
    assert_difference('DeviceHealth.count', -1) do
      delete :destroy, id: @device_health
    end

    assert_redirected_to device_healths_path
  end
end
