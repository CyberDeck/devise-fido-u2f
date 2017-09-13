require 'test_helper'

class FidoUsfAuthenticationsControllerTest < ActionController::TestCase
  tests Devise::FidoUsfAuthenticationsController
  include DeviseFidoUsf::ControllerHelpers

  def setup
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  test "#new without user" do
    get :new
    assert_response :redirect
    assert_redirected_to '/'
  end

  test "#new without user signed in before" do
    user = create_user
    @controller.session[:user_id] = user.id
    get :new
    assert_response :redirect
    assert_redirected_to '/'
  end

  test "#new for logged in user" do
    user = create_user
    @controller.session[:user_id] = user.id
    @controller.session[:user_password_checked] = true
    get :new
    assert @controller.session[:user_u2f_challenge]
    assert_response :success
    assert_template 'devise/fido_usf_authentications/new'
  end

  test "#create without user" do
    post :create
    assert_not @controller.helpers.user_signed_in?
    assert_response :redirect
    assert_redirected_to '/'
  end

  test "#create without user signed in before" do
    user = create_user
    @controller.session[:user_id] = user.id
    post :create
    assert_not @controller.helpers.user_signed_in?
    assert_response :redirect
    assert_redirected_to '/'
  end

  test '#create for empty request' do
    user = create_user
    token = setup_u2f(@controller)
    dev = create_u2f_device(user, token[:key_handle], token[:public_key], token[:certificate])
    @controller.session[:user_id] = user.id
    @controller.session[:user_password_checked] = true
    post :create
    assert_not @controller.helpers.user_signed_in?
    assert_response :redirect
    assert_redirected_to '/'
  end
  
  test '#create for unregistered token' do
    user = create_user
    token = setup_u2f(@controller)
    dev = create_u2f_device(user, 'other handle', token[:public_key], token[:certificate])
    @controller.session[:user_id] = user.id
    @controller.session[:user_password_checked] = true
    @controller.session[:user_u2f_challenge] = U2F.urlsafe_encode64(SecureRandom.random_bytes(32))
    post :create, params: { response: token[:device].sign_response(@controller.session[:user_u2f_challenge]) }
    assert_not @controller.helpers.user_signed_in?
    assert_response :no_content
  end
  
  test '#create for registered token wrong challenge' do
    user = create_user
    token = setup_u2f(@controller)
    dev = create_u2f_device(user, token[:key_handle], token[:public_key], token[:certificate])
    @controller.session[:user_id] = user.id
    @controller.session[:user_password_checked] = true
    @controller.session[:user_u2f_challenge] = U2F.urlsafe_encode64(SecureRandom.random_bytes(32))
    post :create, params: { response: token[:device].sign_response(U2F.urlsafe_encode64(SecureRandom.random_bytes(32))) }
    assert_not @controller.helpers.user_signed_in?
    assert_response :redirect
    assert_redirected_to '/'
  end
  
  test '#create for registered token' do
    user = create_user
    token = setup_u2f(@controller)
    dev = create_u2f_device(user, token[:key_handle], token[:public_key], token[:certificate])
    @controller.session[:user_id] = user.id
    @controller.session[:user_password_checked] = true
    @controller.session[:user_u2f_challenge] = U2F.urlsafe_encode64(SecureRandom.random_bytes(32))
    assert token[:public_key].bytesize == 65 && token[:public_key].byteslice(0) == "\x04"

    post :create, params: { response: token[:device].sign_response(@controller.session[:user_u2f_challenge]) }
    assert @controller.helpers.user_signed_in?
    assert_response :redirect
    assert_redirected_to '/'
  end
  
end
