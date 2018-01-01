module Devise
  module Models
    module FidoUsfRegisterable
      extend ActiveSupport::Concern

      included do
        has_many :fido_usf_devices,
                 as: :user,
                 class_name: 'FidoUsf::FidoUsfDevice',
                 dependent: :destroy
      end
    end
  end
end
