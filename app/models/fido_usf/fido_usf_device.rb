module FidoUsf
  class FidoUsfDevice < ActiveRecord::Base
    belongs_to :user, polymorphic: true

    validates :user, :name, :key_handle, :public_key, :certificate, :counter, :last_authenticated_at, presence: true
  end
end
