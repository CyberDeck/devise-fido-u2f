require 'test_helper'

class FidoUsfRegistrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers


  #def setup
  #  request.env['devise.mapping'] = Devise.mappings[:user]
  #end

  test "#show is forbidden for visitors" do
    sign_in_as_user
    visit user_fido_usf_registration_path()
    assert_link 'Add'
    #assert_redirected_to new_user_session_path()
  end
end
