class Api::AutorespondersController < ApplicationController
  before_action :autoresponder, only: %i[update]

  def index
    api_list_render(Autoresponder)
  end

  def update
    @autoresponder.update_attributes(autoresponder_params)
    respond_with_object_or_message_status(@autoresponder, ApiSuccessSerializer, root: 'autoresponder')
  end

  private

  def autoresponder
    @autoresponder = Autoresponder.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    record_not_found("Autoresponder #{params[:id]} not found")
  end

  def autoresponder_params
    params.require(:autoresponder).permit(
      :active,
      :message
    ).to_unsafe_h.to_snake_keys
  end

  def authorized?
    access_denied unless current_user.admin?
  end
end
