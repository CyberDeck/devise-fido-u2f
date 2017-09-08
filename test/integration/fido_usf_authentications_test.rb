require 'test_helper'

class FidoUsfAuthenticationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "visit without 2fa" do
    visit secret_path()
    assert_no_text 'secret page'
    assert_text 'Log in'
    sign_in_as_user
    visit secret_path()
    assert_text 'secret page'
  end

  test "visit with 2fa active" do
    visit secret_path()
    assert_no_text 'secret page'
    assert_text 'Log in'

    setup_u2f_with_appid(get_fake_ssl_hostname)
    sign_in_as_user({usf_device: {key_handle: @key_handle, public_key: @public_key, certificate: @certificate}})

    assert_no_text 'secret page'
    assert_text 'Authenticate key'

    visit secret_path()
    assert_no_text 'secret page'
    assert_text 'Log in'
  end

  test "visit with 2fa active and valid response" do
    visit secret_path()
    assert_no_text 'secret page'
    assert_text 'Log in'

    setup_u2f_with_appid(get_fake_ssl_hostname)
    sign_in_as_user({usf_device: {key_handle: @key_handle, public_key: @public_key, certificate: @certificate}})

    assert_no_text 'secret page'
    assert_text 'Authenticate key'
    
    challenge = find_javascript_assignment_for_string(page, 'challenge')
    set_hidden_field 'response', @device.sign_response(challenge)
    submit_form! 'form'

    assert_text 'secret page'
  end
end
