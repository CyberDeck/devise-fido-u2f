module DeviseFidoUsf
  class Engine < ::Rails::Engine
    ActiveSupport.on_load(:action_controller) do
      include DeviseFidoUsf::Controllers::Helpers
    end
  end
end
