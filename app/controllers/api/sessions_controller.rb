class Api::SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[show valid_session create destroy]

  def show
    render json: Auth::SessionManager.info(session).to_camelback_keys
  end

  def valid_session
    render json: { valid_session: Auth::SessionManager.valid?(session) }.to_camelback_keys
  end

  def create
    resp = Auth::SessionManager.login(login_params[:email], login_params[:password], session, cookies)
    if resp == true
      render json: Auth::SessionManager.info(session).to_camelback_keys
    else
      unable_to_authenticate(resp)
    end
  end

  def destroy
    ConversationAssignmentManager.reassign_operator_conversations(current_user.user) unless current_user.nil?
    Auth::SessionManager.logout(session, cookies)
    render json: { success: true }
  end

  def auth_token
    info = Chat::UserAuthTokenManager.create_connection(current_user.user.identifier, ChatAccessKey.first.access_key)
    if info.key?(:error)
      unable_to_authenticate(info[:error])
    else
      render json: info.to_camelback_keys
    end
  end

  private

  def login_params
    params.require(:login).permit(:email, :password)
  end
end
