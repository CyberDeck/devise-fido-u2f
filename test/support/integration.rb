require 'action_dispatch/testing/integration'

class ActionDispatch::IntegrationTest
  def warden
    request.env['warden']
  end

  def fake_ssl_post(path, params)
    page.driver.post "#{get_fake_ssl_hostname}#{path}", params
  end

  def get_fake_ssl_hostname
    Capybara.default_host.sub('http', 'https')
  end

  def set_hidden_field(name, value)
    page.find("input[name=#{name}]", visible: false).set(value)
  end

  def submit_form!(locator)
    form = page.find(locator)
    class << form
      def submit!
        Capybara::RackTest::Form.new(driver, native).submit({})
      end
    end
    form.submit!
  end

  def javascript_parser
    @parser ||= RKelly::Parser.new
  end

  def find_ast_for_variable_assignment(ast, variable)
    ast.each do |node| 
      if node.class == RKelly::Nodes::VarStatementNode 
        node.each do |var| 
          if var.class == RKelly::Nodes::VarDeclNode
            if var.name == variable
              return var.value
            end
          end
        end
      end
    end
    return nil
  end

  def find_javascript_assignment_for_array(page, variable)
    page.all('body script', visible: false).each do |el|
      ast = javascript_parser.parse(el.text(:all))
      assignment = find_ast_for_variable_assignment(ast, "registerRequests")
      if assignment.first.class == RKelly::Nodes::AssignExprNode
        value = assignment.first.value
        return JSON.parse(value.to_ecma)
      end
    end
    return nil
  end

  def create_user(options={})
    @user ||= begin
      user = User.create!(
        email: options[:email] || 'user@test.com',
        password: options[:password] || '12345678',
        password_confirmation: options[:password] || '12345678',
        created_at: Time.now.utc
      )
      user.lock_access! if options[:locked] == true
      user
    end
  end

  def sign_in_as_user(options={}, &block)
    user = create_user(options)
    visit_with_option options[:visit], new_user_session_path
    fill_in 'Email', with: options[:email] || 'user@test.com'
    fill_in 'Password', with: options[:password] || '12345678'
    check 'Remember me' if options[:remember_me] == true
    yield if block_given?
    click_button 'Log in'
    user
  end

  # Fix assert_redirect_to in integration sessions because they don't take into
  # account Middleware redirects.
  #
  def assert_redirected_to(url)
    assert [301, 302].include?(@integration_session.status),
           "Expected status to be 301 or 302, got #{@integration_session.status}"

    assert_url url, @integration_session.headers["Location"]
  end

  def assert_current_url(expected)
    assert_url expected, current_url
  end

  def assert_url(expected, actual)
    assert_equal prepend_host(expected), prepend_host(actual)
  end

  protected

    def visit_with_option(given, default)
      case given
      when String
        visit given
      when FalseClass
        # Do nothing
      else
        visit default
      end
    end

    def prepend_host(url)
      url = "http://#{request.host}#{url}" if url[0] == ?/
      url
    end
end
