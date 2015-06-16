require 'test_helper'

class Acm300LogsControllerTest < ActionController::TestCase
  setup do
    @acm300_log = acm300_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:acm300_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create acm300_log" do
    assert_difference('Acm300Log.count') do
      post :create, acm300_log: { acm_module: @acm300_log.acm_module, iin: @acm300_log.iin, iout: @acm300_log.iout, log_date: @acm300_log.log_date, log_time: @acm300_log.log_time, power: @acm300_log.power, vin: @acm300_log.vin, vout: @acm300_log.vout }
    end

    assert_redirected_to acm300_log_path(assigns(:acm300_log))
  end

  test "should show acm300_log" do
    get :show, id: @acm300_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @acm300_log
    assert_response :success
  end

  test "should update acm300_log" do
    patch :update, id: @acm300_log, acm300_log: { acm_module: @acm300_log.acm_module, iin: @acm300_log.iin, iout: @acm300_log.iout, log_date: @acm300_log.log_date, log_time: @acm300_log.log_time, power: @acm300_log.power, vin: @acm300_log.vin, vout: @acm300_log.vout }
    assert_redirected_to acm300_log_path(assigns(:acm300_log))
  end

  test "should destroy acm300_log" do
    assert_difference('Acm300Log.count', -1) do
      delete :destroy, id: @acm300_log
    end

    assert_redirected_to acm300_logs_path
  end
end
