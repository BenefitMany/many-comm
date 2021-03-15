module Authenticators
  extend ActiveSupport::Concern

  def authenticate
    access_denied unless Auth::SessionManager.valid?(session)
    User.current_user_id = session[:user_id]
  end

  def authorized?
    true
  end

  def current_user
    session_token_header_check!
    @current_user ||= Auth::CurrentUser.new(session)
  end
  # helper_method :current_user

  private

  def session_token_header_check!
    access_token = request.headers['X-MANYCOMM-SESSION'] || request.headers['HTTP_X_MANYCOMM_SESSION']
    return if access_token.blank?

    session[:access_token] = access_token
  end
end
