require 'test_helper'

class FidoUsfAuthenticationTest < ActionDispatch::IntegrationTest
  # include Devise::Test::IntegrationHelpers

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

    token = setup_u2f_with_appid(get_fake_ssl_hostname)
    sign_in_as_user({usf_device: token})

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

    token = setup_u2f_with_appid(get_fake_ssl_hostname)
    sign_in_as_user({usf_device: token})

    assert_no_text 'secret page'
    assert_text 'Authenticate key'
    
    challenge = find_javascript_assignment_for_string(page, 'challenge')
    set_hidden_field 'response', token[:device].sign_response(challenge)
    submit_form! 'form'

    assert_text 'secret page'
  end

  test "visit with 2fa active and valid response from two users" do
    visit secret_path()
    assert_no_text 'secret page'
    assert_text 'Log in'

    token = setup_u2f_with_appid(get_fake_ssl_hostname)
    sign_in_as_user_with_token({email: 'other@test.com', usf_device: token})

    assert_text 'secret page'
    sign_out_as_user

    visit secret_path()
    assert_no_text 'secret page'
    assert_text 'Log in'

    token = setup_u2f_with_appid(get_fake_ssl_hostname)
    sign_in_as_user_with_token({usf_device: token})

    assert_text 'secret page'
    sign_out_as_user
  end

  test "visit with 2fa active and other user is using wrong token" do
    visit secret_path()
    assert_no_text 'secret page'
    assert_text 'Log in'

    token = setup_u2f_with_appid(get_fake_ssl_hostname)
    sign_in_as_user_with_token({email: 'other@test.com', usf_device: token})
    assert_text 'secret page'
    sign_out_as_user

    visit secret_path()
    new_token = setup_u2f_with_appid(get_fake_ssl_hostname)
    sign_in_as_user(usf_device: new_token)
    assert_text 'Authenticate key'
    challenge = find_javascript_assignment_for_string(page, 'challenge')
    set_hidden_field 'response', token[:device].sign_response(challenge)
    submit_form! 'form'

    assert_empty page.body
  end

  test "visit with 2fa active and user is using two tokens" do
    visit secret_path()
    assert_no_text 'secret page'
    assert_text 'Log in'

    token_a = setup_u2f_with_appid(get_fake_ssl_hostname)
    token_b = setup_u2f_with_appid(get_fake_ssl_hostname)
    user = sign_in_as_user_with_token({usf_device: token_a})
    create_u2f_device(user, token_b[:key_handle], token_b[:public_key], token_b[:certificate])
    assert_equal 2, user.fido_usf_devices.count()

    assert_text 'secret page'
    sign_out_as_user

    visit secret_path()
    sign_in_as_existing_user_with_token(user, {usf_device: token_a})
    assert_text 'secret page'
    sign_out_as_user

    visit secret_path()
    sign_in_as_existing_user_with_token(user, {usf_device: token_b})
    assert_text 'secret page'
    sign_out_as_user
  end
end
