module Auth
  class CurrentUser
    attr_accessor :user_id, :user

    def self.verify_access_token?(access_token)
      Session.where(access_token: access_token).exists?
    end

    def initialize(user_session)
      unless user_session[:access_token].blank?
        @session = Session.where(access_token: user_session[:access_token]).first
      end
      return if @session.nil? || @session.cached_user.nil?

      @user_id = @session.cached_user[:user_id]
      @user = User.find(@user_id) unless @user_id.nil?
    end

    def admin?
      @user&.admin? || false
    end
  end
end
