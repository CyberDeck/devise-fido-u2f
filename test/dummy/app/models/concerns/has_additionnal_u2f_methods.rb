module HasAdditionnalU2fMethods
  extend ActiveSupport::Concern

  def u2fauth_enabled?
    false
  end
end
