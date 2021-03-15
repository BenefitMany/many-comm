module Auth
  module SecurityHelpers
    def logout_user
      Auth::SessionManager.logout(request.session, request.cookies)
    end

    def authenticate_user(user, existing_session = nil, existing_cookies = nil)
      user.password = 'Simple123'
      user.password_confirmation = 'Simple123'
      user.save
      session_to_use = existing_session
      cookies_to_use = existing_cookies
      if session_to_use.nil?
        session_to_use = defined?(request) ? request.session : {}
      end
      Auth::SessionManager.login(user.email, 'Simple123', session_to_use, cookies_to_use)
    end

    def authenticate_user_for_api(user)
      user.password = 'Simple123'
      user.password_confirmation = 'Simple123'
      user.save
      @temp_session = {}
      @temp_cookies = {}
      Auth::SessionManager.login(user.email, 'Simple123', @temp_session, @temp_cookies)
      allow_any_instance_of(ApplicationController).to receive(:session).and_return(@temp_session)
    end
  end
end
