module ActionDispatch::Routing
  class Mapper
    def devise_fido_usf_registration(mapping, controllers)
      resource :fido_usf_registration, :only => [:show, :new, :create, :destroy],
        :path => mapping.path_names[:fido_usf_registration], :controller => controllers[:fido_usf_registrations] do
      end
    end
    def devise_fido_usf_authentication(mapping, controllers)
      resource :fido_usf_authentication, :only => [:new, :create],
        :path => mapping.path_names[:fido_usf_authentication], :controller => controllers[:fido_usf_authentications] do
      end
    end
  end
end

