class Api::ResourceListsController < ApplicationController
  def number_search
    numbers = CommunicationService::PhoneNumberSearch.process(phone_number_search_params)
    render json: { numbers: numbers }.to_camelback_keys
  end

  private

  def phone_number_search_params
    params.require(:search).permit(
      :areaCode,
      :postalCode,
      :contains
    ).to_unsafe_h.to_snake_keys.symbolize_keys
  end
end
