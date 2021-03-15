module Auth
  class SessionManager
    def self.login(email, password, session, cookies)
      obj = new(email: email, password: password, session: session, cookies: cookies)
      obj.authenticate
    end

    def self.logout(session, cookies)
      obj = new(session: session, cookies: cookies)
      obj.clear_session
    end

    def self.valid?(session)
      return false if session[:access_token].blank?

      Session.where(access_token: session[:access_token]).exists?
    end

    def self.info(session)
      return {} if session[:access_token].nil?

      active_session = Session.find_by_access_token(session[:access_token])
      return {} if active_session.nil?

      active_session.cached_user
    end

    def self.session_data(session)
      return if session[:access_token].blank?

      Session.where(access_token: session[:access_token]).first
    end

    def initialize(options)
      @email = options[:email]
      @password = options[:password]
      @session = options[:session]
      @cookies = options[:cookies]
      @user = nil
      @user_session = nil
    end

    def authenticate
      @user = User.where('LOWER(email) = ?', @email.downcase.strip).first
      return 'Invalid email or password' if @user.nil?
      return 'Invalid email or password' unless @user.authenticate(@password)

      create_user_session

      @session[:user_id] = @user.id
      @session[:access_token] = @user_session.access_token
      @cookies.encrypted[:access_token] = @user_session.access_token if @cookies.respond_to?(:encrypted)
      UserLoginEntry.create(user_id: @user.id)
      true
    end

    def clear_session
      Session.where(access_token: @session[:access_token]).delete_all
      @session.delete(:access_token)
      @cookies.delete(:access_token)
      true
    end

    private

    def create_user_session
      @user_session = Session.create(user_id: @user.id)
      cache_user_data
      @user_session.save!
      true
    end

    def cache_user_data
      @user_session.cached_user = user_data
      @user_session.change_password = @user.password_change
      true
    end

    def user_data
      {
        identifier: @user.identifier,
        access_token: @user_session.access_token,
        admin: @user.admin?,
        user_id: @user.id,
        email: @user.email,
        first_name: @user.first_name,
        last_name: @user.last_name
      }.symbolize_keys
    end
  end
end
