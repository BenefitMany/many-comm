class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  before_action :authorized?
  before_action :authenticate, except: %i[app_start goto_app_start]

  include ApiListMethods
  include ApplicationRouteMethods
  include Authenticators
  include ErrorMessages
  include FileDownload
  include FormatterMethods
  include ObjectResponders
  include PaginationMethods
  include ParamSetters
end
