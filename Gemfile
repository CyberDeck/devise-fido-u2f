source 'https://rubygems.org'

gemspec

rails_version = ENV["RAILS_VERSION"] || "default"
devise_version = ENV["DEVISE_VERSION"] || "default"

rails = case rails_version
when "master"
  {github: "rails/rails"}
when "default"
  "~> 5.0"
else
  "~> #{rails_version}"
end

devise = case devise_version
when "master"
  {github: "plataformatec/devise"}
when "default"
  "~> 4.2"
else
  "~> #{devise_version}"
end

gem "rails", rails
gem "devise", devise
