Warden::Manager.after_authentication do |user, auth, options|
  if user.respond_to?(:with_fido_usf_authentication?)
    if auth.session(options[:scope])[:with_fido_usf_authentication] = user.with_fido_usf_authentication?()
      auth.session(options[:scope])[:id] = user.id
    end
  end
end

