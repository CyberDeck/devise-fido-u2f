require 'active_support/test_case'

class ActiveSupport::TestCase
  def copy_app_files
    destination = File.join(destination_root, "app/helpers")
    FileUtils.mkdir_p(destination)
    FileUtils.cp file_fixture('application_helper.rb'), destination
  end
end
