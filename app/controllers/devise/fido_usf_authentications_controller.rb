class Devise::FidoUsfAuthenticationsController < DeviseController
  before_action :find_resource_and_verify_password, only: [:new, :create]

  def new
    key_handles = @resource.fido_usf_devices.map(&:key_handle)
    @app_id = u2f.app_id
    @sign_requests = u2f.authentication_requests(key_handles)
    @challenge = u2f.challenge
    session[:"#{resource_name}_u2f_challenge"] = @challenge
    render :new
  end

  def create
    begin
      response = U2F::SignResponse.load_from_json(params[:response])
    rescue TypeError
      return redirect_to root_path
    end

    registration = @resource.fido_usf_devices
                            .find_by(key_handle: response.key_handle)
    return 'Need to register first' unless registration

    begin
      u2f.authenticate!(session[:"#{resource_name}_u2f_challenge"], response,
                        registration.public_key, registration.counter)
      registration.update(counter: response.counter,
                          last_authenticated_at: Time.now)

      # Remember the user (if applicable)
      @resource.remember_me = Devise::TRUE_VALUES.include?(session[:"#{resource_name}_remember_me"]) if @resource.respond_to?(:remember_me=)
      sign_in(resource_name, @resource)

      set_flash_message(:notice, :signed_in) if is_navigational_format?
    rescue U2F::Error => e
      flash[:error] = "Unable to authenticate: #{e.class.name}"
      return redirect_to root_path
    ensure
      session.delete(:"#{resource_name}_u2f_challenge")
    end

    respond_with resource, location: after_sign_in_path_for(@resource)
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

  def u2f
    # use base_url as app_id, e.g. 'http://localhost:3000'
    @u2f ||= U2F::U2F.new(request.base_url)
  end
end
