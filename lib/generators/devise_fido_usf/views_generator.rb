require 'rails/generators/base'

module DeviseFidoUsf
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      source_root File.expand_path("../../../../app/views/devise", __FILE__)

      desc "Copies devise-fido-u2f views to your application."


      argument :scope, required: false, default: nil,
                       desc: "The scope to copy views to"

      def copy_views
        view_directory :fido_usf_authentications
        view_directory :fido_usf_registrations
      end

      protected

      def view_directory(name, opt_target_path = nil)
        directory name.to_s, opt_target_path || "#{target_path}/#{name}" do |content|
          if scope
            content.gsub "devise/fido_usf_registrations/device", "#{plural_scope}/fido_usf_registrations/device"
          else
            content
          end
        end
      end

      def target_path
        @target_path ||= "app/views/#{plural_scope || :devise}"
      end

      def plural_scope
        @plural_scope ||= scope.presence && scope.underscore.pluralize
      end
    end
  end
end
