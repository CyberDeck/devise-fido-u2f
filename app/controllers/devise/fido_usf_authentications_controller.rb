class Devise::FidoUsfAuthenticationsController < DeviseController
  before_action :authenticate_user!
  before_action :find_resource_and_verify_password, only: [:new, :create]

  def new
    key_handles = @resource.fido_usf_devices.map(&:key_handle)
    @app_id = helpers.u2f.app_id
    @sign_requests = helpers.u2f.authentication_requests(key_handles)
    @challenge = helpers.u2f.challenge
    session[:"#{resource_name}_u2f_challenge"] = @challenge
    render :new
  end

  def create
    response = U2F::SignResponse.load_from_json(params[:response])
    registration = @resource.fido_usf_devices.find_by_key_handle(response.key_handle)
    return 'Need to register first' unless registration

    begin
      helpers.u2f.authenticate!(session[:"#{resource_name}_u2f_challenge"], response, Base64.decode64(registration.public_key), registration.counter)
    rescue U2F::Error => e
      @error_message = "Unable to authenticate: #{e.class.name}"
    ensure
      session.delete(:"#{resource_name}_u2f_challenge")
    end

    registration.update(counter: response.counter, last_authenticated_at: Time.now)

    # Remember the user (if applicable)
    @resource.remember_me = Devise::TRUE_VALUES.include?(session[:"#{resource_name}_remember_me"]) if @resource.respond_to?(:remember_me=)
    sign_in(resource_name, @resource)

    set_flash_message(:notice, :signed_in) if is_navigational_format?
    respond_with resource, :location => after_sign_in_path_for(@resource)
  end

  private
  def find_resource_and_verify_password
    @resource = send("current_#{resource_name}")
    if @resource.nil?
      @resource = resource_class.find_by_id(session["#{resource_name}_id"])
    end
    if @resource.nil? || !Devise::TRUE_VALUES.include?(session[:"#{resource_name}_password_checked"])
      redirect_to root_path
    end
  end
end
