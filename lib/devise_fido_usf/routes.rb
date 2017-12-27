module ActionDispatch
  module Routing
    #
    # Routes to register U2F devices and to authenticate with a U2F device
    #
    class Mapper
      def devise_fido_usf_registration(mapping, controllers)
        resource :fido_usf_registration,
                 only: %i[show new create update destroy],
                 path: mapping.path_names[:fido_usf_registration],
                 controller: controllers[:fido_usf_registrations]
      end

      def devise_fido_usf_authentication(mapping, controllers)
        resource :fido_usf_authentication,
                 only: %i[new create],
                 path: mapping.path_names[:fido_usf_authentication],
                 controller: controllers[:fido_usf_authentications]
      end
    end
  end
end
