module SendgridManagerLib
  module UserAccountNotifications

    def password_reset_request(user)
      @user = user
      @user.update_perishable_token!
      @url = MANYCOMM_BASE_URL + "/update_password/#{user.perishable_token}"
      sendgrid_options = {
        to: @user.email,
        subject: 'ManyComm Password Reset Request',
        from: MANYCOMM_NOREPLY_EMAIL,
        headline: 'Reset your password',
        name: @user.name,
        message_body: '
          ManyComm received a request for password reset.
          Please use the link below to reset your password. <br/>
          Otherwise ignore this email if you no longer wish to reset your password.
        ',
        cta: true,
        cta_text: 'Reset Password',
        cta_url: @url
      }
      deliver_now(sendgrid_options)
    end

    def password_updated_notification(user)
      @user = user
      sendgrid_options = {
        to: @user.email,
        subject: 'ManyComm Password Updated',
        from: MANYCOMM_NOREPLY_EMAIL,
        name: @user.name,
        message_body: 'Your ManyComm password has been updated.'
      }
      deliver_now(sendgrid_options)
    end

    def user_account_activation(user_id)
      @user = User.find(user_id)
      @user.update_perishable_token!
      @url = MANYCOMM_BASE_URL + "/account/activate/#{@user.perishable_token}"
      sendgrid_options = {
        to: @user.email,
        subject: 'ManyComm Website and ManyComm Account Activation',
        from: MANYCOMM_NOREPLY_EMAIL,
        headline: 'Activate your account',
        name: @user.name,
        message_body: 'Please use the link below to activate your ManyComm account.',
        cta: true,
        cta_text: 'Activate Account',
        cta_url: @url
      }
      deliver_now(sendgrid_options)
    end

    def user_new_email_verification(user)
      @user = user
      @user.update_perishable_token!
      @url = MANYCOMM_BASE_URL + "/account/#{user.perishable_token}/verify"
      sendgrid_options = {
        to: @user.email,
        subject: 'ManyComm New Email Address Verification',
        from: MANYCOMM_NOREPLY_EMAIL,
        headline: 'Verify your email change',
        name: @user.name,
        message_body: '
          Please use the link below to verify your new email address.
          <br/> You can ignore this email if you do not wish to update your email
        ',
        cta: true,
        cta_text: 'Confirm Email',
        cta_url: @url
      }
      deliver_now(sendgrid_options)
    end
  end
end
