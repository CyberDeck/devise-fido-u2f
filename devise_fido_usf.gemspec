$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "devise_fido_usf/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "devise_fido_usf"
  s.version     = DeviseFidoUsf::VERSION
  s.authors     = ["H. Gregor Molter"]
  s.email       = ["gregor.molter@secretlab.de"]
  s.homepage    = "https://github.com/CyberDeck/devise-fido-u2f"
  s.summary     = "A Devise module to allow FIDO U2F authentication."
  s.description = "Enables a Rails Devise app to authenticate users with a second factor, e.g. a FIDO U2F compatible hardware token."
  s.license     = "MIT"
  s.metadata    = {
    "homepage_uri" => "https://github.com/cyberdeck/devise-fido-u2f",
    "changelog_uri" => "https://github.com/cyberdeck/devise-fido-u2f/blob/master/CHANGELOG.md",
    "source_code_uri" => "https://github.com/cyberdeck/devise-fido-u2f/",
    "bug_tracker_uri" => "https://github.com/cyberdeck/devise-fido-u2f/issues",
  }

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'devise', '>= 3.2'
  s.add_dependency 'rails', '>= 4.2'
  s.add_dependency 'thor', '>= 0.20.0'
  s.add_dependency 'u2f', '1.0.0'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "thin"
  s.add_development_dependency "capybara"
  s.add_development_dependency "launchy"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "coveralls_reborn"
  s.add_development_dependency "rkelly-remix"
  s.add_development_dependency "rails-controller-testing"
  s.add_development_dependency "pry"
  s.add_development_dependency "nokogiri", ">= 1.8.1"
end
