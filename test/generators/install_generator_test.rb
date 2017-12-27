require 'test_helper'

class InstallGeneratorTest < Rails::Generators::TestCase
  tests DeviseFidoUsf::Generators::InstallGenerator
  destination File.expand_path('../../tmp', __FILE__)

  setup do
    prepare_destination
    copy_app_files
  end

  test 'assert all files are properly created' do
    run_generator(['--orm=active_record'])
    assert_file 'config/locales/fido_usf.en.yml'
    assert_migration 'db/migrate/create_fido_usf_devices.rb', /def change/
  end

  test 'fails if no ORM is specified' do
    stderr = capture(:stderr) do
      run_generator
    end

    assert_match(/An ORM must be set to install Devise/, stderr)

    assert_no_file 'config/locales/fido_usf.en.yml'
    assert_no_migration 'db/migrate/create_fido_usf_devices.rb'
  end
end
