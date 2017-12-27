# Code loosely based on authy-devise gem from https://github.com/authy/authy-devise

module DeviseFidoUsf
  module Controllers
    module Helpers
      extend ActiveSupport::Concern

      included do
        before_action :check_request_and_redirect_to_verify_fido_usf,
                      if: :is_user_signing_in?
      end

      private
      def is_devise_sessions_controller?
        self.class == Devise::SessionsController || self.class.ancestors.include?(Devise::SessionsController)
      end

      def is_user_signing_in?
        if devise_controller? && signed_in?(resource_name) &&
          is_devise_sessions_controller? &&
          self.action_name == "create"
          return true
        end

        return false
      end

      def check_request_and_redirect_to_verify_fido_usf
        if signed_in?(resource_name) && warden.session(resource_name)[:with_fido_usf_authentication]
          # login with 2fa
          id = warden.session(resource_name)[:id]

          return_to = session["#{resource_name}_return_to"]
          remember_me = Devise::TRUE_VALUES.include?(sign_in_params[:remember_me])
          sign_out

          # It is secure to put these information in a Rails 5 session
          # because cookies are signed and encrypted.
          session["#{resource_name}_id"] = id
          session["#{resource_name}_remember_me"] = remember_me
          session["#{resource_name}_password_checked"] = true
          session["#{resource_name}_return_to"] = return_to if return_to

          redirect_to verify_fido_usf_path_for(resource_name)
          return
        end
      end

      def verify_fido_usf_path_for(resource_or_scope = nil)
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        send(:"new_#{scope}_fido_usf_authentication_path")
      end
    end
  end
end
