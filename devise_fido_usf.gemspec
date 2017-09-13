$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "devise_fido_usf/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "devise_fido_usf"
  s.version     = DeviseFidoUsf::VERSION
  s.authors     = ["H. Gregor Molter"]
  s.email       = ["gregor.molter@secretlab.de"]
  s.homepage    = "https://github.com/CyberDeck/devise-fido-u2f/"
  s.summary     = "A Devise module to allow FIDO U2F authentication."
  s.description = "Enables a Rails Devise app to authenticate users with a second factor, e.g. a FIDO U2F compatible hardware token."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1"
  s.add_dependency "devise", "~> 4.3"
  s.add_dependency "u2f", "1.0.0"
  s.add_dependency "thor", ">= 0.20.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "thin"
  s.add_development_dependency "capybara"
  s.add_development_dependency "launchy"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "coveralls"
  s.add_development_dependency "rkelly-remix"
  s.add_development_dependency "rails-controller-testing"
  s.add_development_dependency "pry"
end
