class Devise::FidoUsfRegistrationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @registration_requests = u2f.registration_requests
    session[:challenges] = @registration_requests.map(&:challenge)
    key_handles = current_user.fido_usf_devices.map(&:key_handle)
    @sign_requests = u2f.authentication_requests(key_handles)
    @app_id = u2f.app_id
    render :new
  end

  # Show a list of all registered devices
  def show
    @devices = current_user.fido_usf_devices.all
    render :show
  end

  def destroy
    device = current_user.fido_usf_devices.find(params[:id])
    @fade_out_id = device.id
    device.destroy
    @devices = current_user.fido_usf_devices.all
    flash[:success] = I18n.t('fido_usf.flashs.device.removed')
    respond_to do |format|
      format.js
      format.html { redirect_to user_fido_usf_registration_url }
    end
  end

  def create
    begin
      response = U2F::RegisterResponse.load_from_json(params[:response])
      reg = u2f.register!(session[:challenges], response)

      pubkey = reg.public_key
      pubkey = Base64.decode64(reg.public_key) unless pubkey.bytesize == 65 && pubkey.byteslice(0) != "\x04" 
      
      @device = FidoUsf::FidoUsfDevice.create!(
          user: current_user,
          name: "Token ##{current_user.fido_usf_devices.count+1}",
          certificate: reg.certificate,
          key_handle: reg.key_handle,
          public_key: pubkey,
          counter: reg.counter,
          last_authenticated_at: Time.now)
      flash[:success] = I18n.t('fido_usf.flashs.device.registered')
    rescue U2F::Error => e
      @error_message = "Unable to register: #{e.class.name}"
      flash[:error] = @error_message 
    ensure
      session.delete(:challenges)
    end

    respond_to do |format|
      format.js
      format.html { redirect_to user_fido_usf_registration_url }
    end
  end

  def update
    device = current_user.fido_usf_devices.find(params[:id])
    device.update!(fido_usf_params)
    respond_to do |format|
      format.js
      format.html { redirect_to user_fido_usf_registration_url }
    end
  end

  private

  def fido_usf_params
    # Only allow to update the name
    params.require(:fido_usf_device).permit(:name)
  end

  def u2f
    # use base_url as app_id, e.g. 'http://localhost:3000'
    @u2f ||= U2F::U2F.new(request.base_url)
  end
end
