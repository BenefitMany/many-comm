class Api::PhoneNumbersController < ApplicationController
  before_action :phone_number, only: %i[show update destroy reset_password]

  def index
    api_list_render(PhoneNumber)
  end

  def show
    render json: @phone_number
  end

  def create
    @phone_number = PhoneNumber.create(create_phone_number_params)
    CommunicationService::PhoneNumberManager.create(phone_number_id: @phone_number.id) if @phone_number.valid?
    respond_with_object_or_message_status(@phone_number, ApiSuccessSerializer, root: 'phone_number')
  end

  def update
    @phone_number.update_attributes(update_phone_number_params)
    CommunicationService::PhoneNumberManager.update(phone_number_id: @phone_number.id) if @phone_number.valid?
    respond_with_object_or_message_status(@phone_number, ApiSuccessSerializer, root: 'phone_number')
  end

  def destroy
    mark_deleted_or_respond_with_message_status(@phone_number) do
      unless @phone_number.deleted_at.nil?
        CommunicationService::PhoneNumberManager.delete(phone_number_id: @phone_number.id)
      end
    end
  end

  private

  def translated_column
    case sort_column
    when 'number' then 'number'
    when 'createdAt' then 'created_at'
    when 'deletedAt' then 'deleted_at'
    else 'name' # name
    end
  end

  def create_phone_number_params
    params.require(:phoneNumber).permit(:name, :number).to_unsafe_h.to_snake_keys
  end

  def update_phone_number_params
    params.require(:phoneNumber).permit(:name).to_unsafe_h.to_snake_keys
  end

  def phone_number
    @phone_number = PhoneNumber.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    record_not_found("Phone number #{params[:id]} not found")
  end

  def authorized?
    access_denied unless current_user.admin?
  end
end
