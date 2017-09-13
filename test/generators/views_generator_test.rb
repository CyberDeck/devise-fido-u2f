require "test_helper"

class ViewsGeneratorTest < Rails::Generators::TestCase
  tests DeviseFidoUsf::Generators::ViewsGenerator
  destination File.expand_path("../../tmp", __FILE__)
  setup :prepare_destination

  test "Assert all views are properly created with no params" do
    run_generator
    assert_files
    assert_device_links
  end

  test "Assert all views are properly created with scope param" do
    run_generator %w(users)
    assert_files "users"
    assert_device_links "users"

    run_generator %w(admins)
    assert_files "admins"
    assert_device_links "admins"
  end

  def assert_files(scope = nil, options={})
    scope = "devise" if scope.nil?
    assert_file "app/views/#{scope}/fido_usf_registrations/destroy.js.erb"
    assert_file "app/views/#{scope}/fido_usf_registrations/new.html.erb"
    assert_file "app/views/#{scope}/fido_usf_registrations/_devices.html.erb"
    assert_file "app/views/#{scope}/fido_usf_registrations/show.html.erb"
    assert_file "app/views/#{scope}/fido_usf_registrations/_device.html.erb"
    assert_file "app/views/#{scope}/fido_usf_authentications/new.html.erb"
  end

  def assert_device_links(scope = nil)
    scope = "devise" if scope.nil?

    link_devices = /<%= render '#{scope}\/fido_usf_registrations\/devices %>'/
    link_device = /<%= render partial: '#{scope}\/fido_usf_registrations\/device', collection: @devices %>/

    assert_file "app/views/#{scope}/fido_usf_registrations/show.html.erb", link_devices
    assert_file "app/views/#{scope}/fido_usf_registrations/_devices.html.erb", link_device
  end
end
