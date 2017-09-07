module DeviseFidoUsf
  module Controllers
    autoload :Helpers, 'devise_fido_usf/controllers/helpers'
  end
end

require 'devise'
require 'u2f'
require 'devise_fido_usf/routes'
require 'devise_fido_usf/rails'

Devise.add_module :fido_usf_registerable, :model => 'devise_fido_usf/models/fido_usf_registerable', :controller => :fido_usf_registrations, :route => :fido_usf_registration
Devise.add_module :fido_usf_authenticatable, :model => 'devise_fido_usf/models/fido_usf_authenticatable', :controller => :fido_usf_authentications, :route => :fido_usf_authentication
