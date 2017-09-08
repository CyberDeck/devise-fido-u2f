require 'active_support/test_case'

class ActiveSupport::TestCase
  VALID_AUTHENTICATION_TOKEN = 'AbCdEfGhIjKlMnOpQrSt'.freeze

  def setup_mailer
    ActionMailer::Base.deliveries = []
  end

  def store_translations(locale, translations, &block)
    # Calling 'available_locales' before storing the translations to ensure
    # that the I18n backend will be initialized before we store our custom
    # translations, so they will always override the translations for the
    # YML file.
    I18n.available_locales
    I18n.backend.store_translations(locale, translations)
    yield
  ensure
    I18n.reload!
  end

  def generate_unique_email
    @@email_count ||= 0
    @@email_count += 1
    "test#{@@email_count}@example.com"
  end

  def valid_attributes(attributes={})
    { email: generate_unique_email,
      password: '12345678',
      password_confirmation: '12345678' }.update(attributes)
  end

  def new_user(attributes={})
    User.new(valid_attributes(attributes))
  end

  def create_user(attributes={})
    User.create!(valid_attributes(attributes))
  end

  def create_u2f_device(user, key_handle, public_key, certificate, attributes={})
    attrib = {
      user: user,
      name: 'Unnamed 1',
      key_handle: key_handle,
      public_key: public_key,
      certificate: certificate,
      counter: 0,
      last_authenticated_at: Time.now}.update(attributes)
    FidoUsf::FidoUsfDevice.create!(attrib)
  end

  # Execute the block setting the given values and restoring old values after
  # the block is executed.
  def swap(object, new_values)
    old_values = {}
    new_values.each do |key, value|
      old_values[key] = object.send key
      object.send :"#{key}=", value
    end
    clear_cached_variables(new_values)
    yield
  ensure
    clear_cached_variables(new_values)
    old_values.each do |key, value|
      object.send :"#{key}=", value
    end
  end

  def clear_cached_variables(options)
    if options.key?(:case_insensitive_keys) || options.key?(:strip_whitespace_keys)
      Devise.mappings.each do |_, mapping|
        mapping.to.instance_variable_set(:@devise_parameter_filter, nil)
      end
    end
  end

  def setup_u2f(controller)
    @device = U2F::FakeU2F.new(controller.helpers.u2f.app_id)
    @key_handle = U2F.urlsafe_encode64(@device.key_handle_raw)
    @certificate = Base64.strict_encode64(@device.cert_raw)
    @public_key = @device.origin_public_key_raw
  end

  def setup_u2f_with_appid(app_id)
    @device = U2F::FakeU2F.new(app_id)
    @key_handle = U2F.urlsafe_encode64(@device.key_handle_raw)
    @certificate = Base64.strict_encode64(@device.cert_raw)
    @public_key = @device.origin_public_key_raw
  end
end
