require 'test_helper'

class FlukesControllerTest < ActionController::TestCase
  setup do
    @fluke = flukes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:flukes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fluke" do
    assert_difference('Fluke.count') do
      post :create, fluke: { dioalarm: @fluke.dioalarm, flowrate: @fluke.flowrate, irr_py1: @fluke.irr_py1, irr_py2: @fluke.irr_py2, irr_rc1: @fluke.irr_rc1, irr_rc2: @fluke.irr_rc2, log_time: @fluke.log_time, off: @fluke.off, tempC: @fluke.tempC, temp_amb: @fluke.temp_amb, temp_bbox: @fluke.temp_bbox, temp_hxi: @fluke.temp_hxi, temp_hxo: @fluke.temp_hxo, temp_pv1: @fluke.temp_pv1, temp_pv2: @fluke.temp_pv2, temp_pv3: @fluke.temp_pv3, temp_pv4: @fluke.temp_pv4, temp_pv5: @fluke.temp_pv5, temp_pv6: @fluke.temp_pv6, temp_rc1: @fluke.temp_rc1, temp_rc2: @fluke.temp_rc2, temp_wtb: @fluke.temp_wtb, temp_wtt: @fluke.temp_wtt, total: @fluke.total }
    end

    assert_redirected_to fluke_path(assigns(:fluke))
  end

  test "should show fluke" do
    get :show, id: @fluke
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fluke
    assert_response :success
  end

  test "should update fluke" do
    patch :update, id: @fluke, fluke: { dioalarm: @fluke.dioalarm, flowrate: @fluke.flowrate, irr_py1: @fluke.irr_py1, irr_py2: @fluke.irr_py2, irr_rc1: @fluke.irr_rc1, irr_rc2: @fluke.irr_rc2, log_time: @fluke.log_time, off: @fluke.off, tempC: @fluke.tempC, temp_amb: @fluke.temp_amb, temp_bbox: @fluke.temp_bbox, temp_hxi: @fluke.temp_hxi, temp_hxo: @fluke.temp_hxo, temp_pv1: @fluke.temp_pv1, temp_pv2: @fluke.temp_pv2, temp_pv3: @fluke.temp_pv3, temp_pv4: @fluke.temp_pv4, temp_pv5: @fluke.temp_pv5, temp_pv6: @fluke.temp_pv6, temp_rc1: @fluke.temp_rc1, temp_rc2: @fluke.temp_rc2, temp_wtb: @fluke.temp_wtb, temp_wtt: @fluke.temp_wtt, total: @fluke.total }
    assert_redirected_to fluke_path(assigns(:fluke))
  end

  test "should destroy fluke" do
    assert_difference('Fluke.count', -1) do
      delete :destroy, id: @fluke
    end

    assert_redirected_to flukes_path
  end
end
