class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true
end
