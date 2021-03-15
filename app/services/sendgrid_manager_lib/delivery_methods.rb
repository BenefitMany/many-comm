module SendgridManagerLib
  module DeliveryMethods
    require 'sendgrid-ruby'
    include SendGrid

    # rubocop:disable Metrics/AbcSize
    def deliver_now(sendgrid_options)
      mail = Mail.new
      mail.from = Email.new(email: sendgrid_options[:from])
      personalization = Personalization.new
      tos = [sendgrid_options[:to]].flatten.compact
      bccs = [sendgrid_options[:bcc]].flatten.compact
      ccs = [sendgrid_options[:cc]].flatten.compact

      tos.each_with_index do |to_address, t_indx|
        personalization.add_to(env_address(to_address, "to#{t_indx}"))
      end
      bccs.each_with_index do |bcc_address, b_indx|
        personalization.add_bcc(env_address(bcc_address, "bcc#{b_indx}"))
      end
      ccs.each_with_index do |cc_address, c_indx|
        personalization.add_cc(env_address(cc_address, "cc#{c_indx}"))
      end
      personalization.add_dynamic_template_data(
        subject: sendgrid_add_subject(sendgrid_options[:subject]),
        name: sendgrid_options[:name],
        cta: sendgrid_options[:cta],
        cta_text: sendgrid_options[:cta_text],
        cta_url: sendgrid_options[:cta_url],
        message_body: sendgrid_options[:message_body],
        headline: sendgrid_options[:headline], # If Action Required need headline and CTA
        list: sendgrid_options[:list]
      )
      mail.add_personalization(personalization)
      mail.template_id = SENDGRID_TEMPLATE_ID

      if sendgrid_options.key?(:attachment)
        attachment = sendgrid_add_attachment(sendgrid_options[:attachment])
        mail.add_attachment(attachment)
      end

      sg = SendGrid::API.new(api_key: SENDGRID_API_KEY)
      begin
        response = sg.client.mail._('send').post(request_body: mail.to_json)
      # rubocop:disable Lint/RescueException
      rescue Exception => e
        puts e.message
      end
      # rubocop:enable Lint/RescueException
      { status_code: response&.status_code, personalization: personalization, attachment: attachment }
    end
    # rubocop:enable Metrics/AbcSize

    def sendgrid_add_attachment(attachment_options)
      attachment = Attachment.new
      attachment.content = Base64.strict_encode64(attachment_options[:content])
      attachment.type = attachment_options[:type]
      attachment.filename = attachment_options[:filename]
      attachment.disposition = 'attachment'
      attachment.content_id = attachment_options[:filename]
      attachment
    end

    def sendgrid_add_subject(subject)
      return subject if Rails.env.production?

      "DEVELOPMENT: #{subject}"
    end

    def email_address_to_send(address, context)
      return address if Rails.env.production?

      MANYCOMM_DEV_EMAIL.split('@').join("+#{context}@")
    end

    def env_address(address, context)
      email_to_send_to = email_address_to_send(address, context)
      Email.new(email: email_to_send_to)
    end
  end
end
