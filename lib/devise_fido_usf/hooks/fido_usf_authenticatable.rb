Warden::Manager.after_authentication do |user, auth, options|
  u2fauth_enabled = true
  u2fauth_enabled = user.u2fauth_enabled? if user.respond_to?(:u2fauth_enabled?)

  if u2fauth_enabled
    if user.respond_to?(:with_fido_usf_authentication?)
      with_fido_usf_authentication = user.with_fido_usf_authentication?
      scope = auth.session(options[:scope])
      scope[:with_fido_usf_authentication] = with_fido_usf_authentication

      scope[:id] = user.id if with_fido_usf_authentication
    end
  end
end
