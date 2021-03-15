module ManyCommSpecHelpers
  def default_data_info
    init_autoresponders
    init_users
  end

  def init_autoresponders
    message = 'No operator available. Please try again later.'
    Autoresponder::RESPONDER_TYPES.each do |type|
      Autoresponder.create(response_type: type, active: true, message: message)
    end
  end

  def init_users
    return unless @test_admin_user.nil?
    @test_admin_user = FactoryBot.create(:user, admin: true)
    @test_user = FactoryBot.create(:user, admin: false)
    set_default_password(@test_admin_user)
    set_default_password(@test_user)
    conversation_data(@test_user)
  end

  def set_default_password(user)
    user.password = 'Simple123'
    user.password_confirmation = 'Simple123'
    user.save
  end

  def conversation_data(user)
    conversation = FactoryBot.create(:conversation, user_id: user.id)
    visitor = conversation.visitor
    conversation.messages.create(messageable: visitor, message: "Hello, I've been in an abusive relationship for a while. Can you help?")
    conversation.messages.create(messageable: user, message: "Yes, what's your zip code? We can give you resources near by.")
    conversation.messages.create(messageable: visitor, message: '89436')
    conversation.messages.create(messageable: user, message: "Okay in that area we have a Women's Shelter off 5th and Rock. Do you have any children that need protection too?")
    conversation.messages.create(messageable: visitor, message: 'Yes, I have two young boys.')
    conversation.messages.create(messageable: user, message: "The Women's Shelter will let them in, we have additional help there that can provide more services.")
    conversation.messages.create(messageable: visitor, message: "Thank you so much for the help, I'm going to head over there now")
  end
end
