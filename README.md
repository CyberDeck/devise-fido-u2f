# FIDO U2F Authentication for Rails Devise

[![Gem Version](https://badge.fury.io/rb/devise_fido_usf.svg)](https://badge.fury.io/rb/devise_fido_usf)
[![Dependency Status](https://gemnasium.com/badges/github.com/CyberDeck/devise-fido-u2f.svg)](https://gemnasium.com/github.com/CyberDeck/devise-fido-u2f)
[![Security](https://hakiri.io/github/CyberDeck/devise-fido-u2f/master.svg)](https://hakiri.io/github/CyberDeck/devise-fido-u2f/master)

[![Build Status](https://travis-ci.org/CyberDeck/devise-fido-u2f.svg?branch=master)](https://travis-ci.org/CyberDeck/devise-fido-u2f)
[![Code Climate](https://codeclimate.com/github/CyberDeck/devise-fido-u2f/badges/gpa.svg)](https://codeclimate.com/github/CyberDeck/devise-fido-u2f)
[![Coverage Status](https://coveralls.io/repos/github/CyberDeck/devise-fido-u2f/badge.svg)](https://coveralls.io/github/CyberDeck/devise-fido-u2f)

A gem which allows Rails Devise users to authenticate against a second factor.

## Getting started
Devise FIDO U2F works with Rails 5.1 and Devise 4.3 onwards. You need to add it to your application's Gemfile with:

```ruby
gem 'devise_fido_usf'
```

Afterwards, run `bundle install` to install it.

Before being able to use it you need to set it up by running its installation generator:

```bash
$ rails generate devise_fido_usf:install
```

During installation some instructions will be output to your console. Please follow these instructions carefully.
Specifically, you need to adapt your Devise models to include both the FIDO U2F registration and authentication modules. For example you need to add to `app/models/user.rb` the following lines:


```ruby
devise :fido_usf_registerable, :fido_usf_authenticatable', ...

```

Please ensure that the CSRF token check is always prepended on the action chain of your `ApplicationController`. Edit file `app/controllers/application_controller.rb` and change the `protect_from_forgery` line to include `prepend: true`:

```ruby
class ApplicationController < ActionController::Base
  # Prepend the verification of the CSRF token before the action chain.
  protect_from_forgery with: :exception, prepend: true
  ...
end

```

You need to include `u2f-api.js` in your javascript's asset chain by editing `app/assets/javascript/application.js` to include:

```javascript
//= require u2f-api
```

Now Devise with FIDO U2F is activated. Before using it, you need to migrate pending database changes by executing

```bash
$ rails db:migrate
```

Remember: To use it you always needs to run your development server with SSL. Otherwise, the FIDO U2F protocol will not allow registration or authentication!

## Contributing
This is my first developed and published gem. If you find something unusual or uncommon within my code, please drop me a note how to fix it or make it better. Thank you!

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
