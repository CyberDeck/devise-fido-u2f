module Devise
  module Models
    module FidoUsfRegisterable
      extend ActiveSupport::Concern

      included do
        has_many :fido_usf_devices, class_name: 'FidoUsf::FidoUsfDevice', foreign_key: 'user_id', dependent: :destroy
      end
    end
  end
end
