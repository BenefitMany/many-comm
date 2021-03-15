class InitAutoreponders < ActiveRecord::Migration[5.2]
  def change
    message = 'No operator available. Please try again later.'
    Autoresponder::RESPONDER_TYPES.each do |type|
      Autoresponder.create(response_type: type, active: true, message: message)
    end
  end
end
