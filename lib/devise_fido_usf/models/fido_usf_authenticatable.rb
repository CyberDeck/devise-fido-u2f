require 'devise_fido_usf/hooks/fido_usf_authenticatable'

module Devise
  module Models
    module FidoUsfAuthenticatable
      extend ActiveSupport::Concern

      # Does the user has a registered FIDO U2F device?
      def with_fido_usf_authentication?()
        FidoUsf::FidoUsfDevice.where(user: self).count()>0
      end

    end
  end
end
