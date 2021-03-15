class Api::ChatAccessKeysController < ApplicationController
  before_action :chat_access_key, only: %i[destroy]

  def index
    api_list_render(ChatAccessKey)
  end

  def create
    @chat_access_key = ChatAccessKey.create
    respond_with_object_or_message_status(@chat_access_key, ApiSuccessSerializer, root: 'chat_access_key')
  end

  def destroy
    destroy_or_respond_with_message_status(@chat_access_key)
  end

  private

  def chat_access_key
    @chat_access_key = ChatAccessKey.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    record_not_found("Chat access key #{params[:id]} not found")
  end

  def authorized?
    access_denied unless current_user.admin?
  end
end
