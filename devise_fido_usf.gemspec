$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "devise_fido_usf/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "devise_fido_usf"
  s.version     = DeviseFidoUsf::VERSION
  s.authors     = ["H. Gregor Molter"]
  s.email       = ["gregor.molter@secretlab.de"]
  s.homepage    = "http://localhost/"
  s.summary     = "Summary of DeviseFidoUsf."
  s.description = "Description of DeviseFidoUsf."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 5.0.0"
  s.add_dependency "devise", ">= 4.2.0"

  s.add_development_dependency "sqlite3"
end
