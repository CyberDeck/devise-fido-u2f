require 'test_helper'

class FidoUsfRegistrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "#show with valid user" do
    sign_in_as_user
    visit user_fido_usf_registration_path()
    assert_link 'Add'
    #assert_redirected_to new_user_session_path()
  end

  test "#new with valid user" do
    sign_in_as_user
    visit new_user_fido_usf_registration_path()
    #^assert session[:challenge]
    #assert_redirected_to new_user_session_path()
  end

  test "#create for logged in user with valid token" do
    sign_in_as_user
    
    visit new_user_fido_usf_registration_path()
    registerRequests = find_javascript_assignment_for_array(page, 'registerRequests')
    assert registerRequests[0]["challenge"]
    token = setup_u2f_with_appid(get_fake_ssl_hostname)
    # Set response
    set_hidden_field 'response', token[:device].register_response(registerRequests[0]['challenge'])
    submit_form! 'form'

    # We have added the device!
    assert_text I18n.t('fido_usf.flashs.device.registered')

    # Check that the device may be deleted
    visit user_fido_usf_registration_path()
    assert_link 'Delete'
  end

  test "#create for logged in user with invalid token" do
    sign_in_as_user
    
    visit new_user_fido_usf_registration_path()
    registerRequests = find_javascript_assignment_for_array(page, 'registerRequests')
    assert registerRequests[0]["challenge"]
    token = setup_u2f_with_appid(get_fake_ssl_hostname)
    # Set response
    set_hidden_field 'response', token[:device].register_response(registerRequests[0]['challenge'], error=true)
    submit_form! 'form'

    # We failed to add the device!
    assert_text 'Unable to register'

    # No device to delete
    visit user_fido_usf_registration_path()
    assert_no_link 'Delete'
  end

  test "#destroy for logged in user with valid token" do
    sign_in_as_user
    
    visit new_user_fido_usf_registration_path()
    registerRequests = find_javascript_assignment_for_array(page, 'registerRequests')
    assert registerRequests[0]["challenge"]
    token = setup_u2f_with_appid(get_fake_ssl_hostname)
    # Set response
    set_hidden_field 'response', token[:device].register_response(registerRequests[0]['challenge'])
    submit_form! 'form'

    # We have added the device!
    assert_text I18n.t('fido_usf.flashs.device.registered')

    visit user_fido_usf_registration_path()
    assert_link 'Delete'

    # Now delete it
    click_link 'Delete'
    assert_text I18n.t('fido_usf.flashs.device.removed')

    visit user_fido_usf_registration_path()
    assert_no_link 'Delete'
  end

end
