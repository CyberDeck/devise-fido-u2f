require 'test_helper'

class FidoUsfRegistrationsControllerTest < ActionController::TestCase
  tests Devise::FidoUsfRegistrationsController
  include Devise::Test::ControllerHelpers

  def setup
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  test "#new is forbidden for visitors" do
    get :new 
    assert_nil @controller.session[:challenges]
    assert_response :redirect
    assert_redirected_to new_user_session_path()
  end

  test "#new for logged in user" do
    user = create_user
    sign_in user
    get :new
    assert @controller.session[:challenges]
    assert_response :success
    assert_template 'devise/fido_usf_registrations/new'
  end
  
  test "#show is forbidden for visitors" do
    get :show 
    assert_response :redirect
    assert_redirected_to new_user_session_path()
  end

  test "#show for logged in user" do
    user = create_user
    sign_in user
    get :show 
    assert_response :success
    assert_template 'devise/fido_usf_registrations/show'
  end

  test "#create is forbidden for visitors" do
    post :create
    assert_response :redirect
    assert_redirected_to new_user_session_path()
  end

  test "#create for logged in user with valid token" do
    user = create_user
    sign_in user
    get :new
    assert @controller.session[:challenges]
    token = setup_u2f(@controller)
    assert_difference 'user.fido_usf_devices.count()', +1 do
      post :create, params: { response: token[:device].register_response(@controller.session[:challenges][0]) }
    end
    assert_response :redirect
    assert_redirected_to root_path()
  end

  test "#create for logged in user with invalid challenge" do
    user = create_user
    sign_in user
    get :new
    assert @controller.session[:challenges]
    token = setup_u2f(@controller)
    assert_no_difference 'user.fido_usf_devices.count()' do
      post :create, params: { response: token[:device].register_response(@controller.session[:challenges][0], error=true) }
    end
    assert_response :redirect
    assert_redirected_to root_path()
  end

  test "#destroy valid token" do
    user = create_user
    token = setup_u2f(@controller)
    dev = create_u2f_device(user, token[:key_handle], token[:public_key], token[:certificate])
    sign_in user
    assert_difference 'user.fido_usf_devices.count()', -1 do
      post :destroy, params: { id: dev.id }
    end
  end

  test "#destroy invalid token" do
    user = create_user
    other = create_user
    token = setup_u2f(@controller)
    dev = create_u2f_device(other, token[:key_handle], token[:public_key], token[:certificate])
    sign_in user
    assert_no_difference 'user.fido_usf_devices.count()' do
      assert_raises ActiveRecord::RecordNotFound do
        post :destroy, params: { id: dev.id }
      end
    end
  end

  test "#update name" do
    user = create_user
    token = setup_u2f(@controller)
    dev = create_u2f_device(user, token[:key_handle], token[:public_key], token[:certificate])
    sign_in user
    post :update, params: { id: dev.id, fido_usf_device: {name: "New name"} }
    assert dev.reload.name, "New name"
  end

  test "#update name for wrong user" do
    user = create_user
    other = create_user
    token = setup_u2f(@controller)
    dev = create_u2f_device(other, token[:key_handle], token[:public_key], token[:certificate])
    sign_in user
    assert_raises ActiveRecord::RecordNotFound do
      post :update, params: { id: dev.id, fido_usf_device: {name: "New name"} }
    end
    assert_not_equal dev.reload.name, "New name"
  end

  test "#update with illegal parameters" do
    user = create_user
    token = setup_u2f(@controller)
    dev = create_u2f_device(user, token[:key_handle], token[:public_key], token[:certificate])
    sign_in user
    old_key_handle = dev.key_handle
    post :update, params: { id: dev.id, fido_usf_device: {key_handle: "New name"} }
    assert dev.reload.key_handle, old_key_handle
  end
end
