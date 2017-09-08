require 'test_helper'

class FidoUsfRegistrationsControllerTest < ActionController::TestCase
  tests Devise::FidoUsfRegistrationsController
  include Devise::Test::ControllerHelpers

  def setup
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  test "#new is forbidden for visitors" do
    get :new 
    assert_response :redirect
    assert_redirected_to new_user_session_path()
  end

  test "#new for logged in user" do
    user = create_user
    sign_in user
    get :new
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
end
