require 'rails/generators/active_record'

module DeviseFidoUsf
  module Generators
    class MigrateGenerator < ActiveRecord::Generators::Base
      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates the migration for the table which stores all registered FIDO USF devices."

      def copy_fido_usf_device_migration
        migration_template "migration.rb", "db/migrate/create_#{table_name}.rb", migration_version: migration_version
      end

      def rails5?
        Rails.version.start_with? '5'
      end

      def migration_version
        if rails5?
          "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
        end
      end
    end
  end
end

