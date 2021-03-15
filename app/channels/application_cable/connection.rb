module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      # puts "\n\n**************************************************"
      # puts "ApplicationCable Connection access_token: #{cookies.encrypted[:access_token]}"
      # puts "**************************************************\n\n"
      self.current_user = find_verified_user
      validate_access_key!
    end

    def disconnect
      # puts "\n\n**************************************************"
      # puts "ApplicationCable Disconnect access_token: #{cookies.encrypted[:access_token]}"
      # puts "**************************************************\n\n"
      # Any cleanup work needed when the cable connection is cut.
    end

    protected

    def validate_access_key!
      return if request.params[:visitor].blank?
      return if ChatAccessKey.where(access_key: request.params[:visitor]).exists?

      reject_unauthorized_connection
    end

    def find_verified_user
      return if request.params[:visitor].present?

      reject_unauthorized_connection unless Auth::CurrentUser.verify_access_token?(cookies.encrypted[:access_token])
      Auth::CurrentUser.new(access_token: cookies.encrypted[:access_token])
    end
  end
end
