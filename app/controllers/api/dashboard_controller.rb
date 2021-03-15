class Api::DashboardController < ApplicationController
  def show
    data = {
      recentChatMessages: 20
    }
    render json: data.to_camelback_keys
  end
end
