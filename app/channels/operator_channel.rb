class OperatorChannel < ApplicationCable::Channel
  def subscribed
    # puts '****************************************'
    # puts 'OperatorChannel Subscribed'
    # puts '****************************************'
    return if current_user.nil?

    stream_from 'operator_channel'
    current_user.user.update_column(:user_status, 'available')
  end

  def unsubscribed
    # puts '****************************************'
    # puts 'OperatorChannel unsubscribed'
    # puts '****************************************'
    return if current_user.nil?

    # Any cleanup needed when channel is unsubscribed
    # stop_all_streams
    current_user.user.update_column(:user_status, nil)
    payload = {
      operator_change: {
        id: current_user.user_id,
        first_name: current_user.user.first_name,
        last_name: current_user.user.last_name,
        status: current_user.user.user_status
      }
    }
    ActionCable.server.broadcast 'operator_channel', payload.to_camelback_keys
  end

  def speak(data)
    # puts '****************************************'
    # puts "OperatorChannel speak(#{data})"
    # puts '****************************************'
    info = data.to_snake_keys.symbolize_keys
    case data['method']
    when 'operator_list' then operator_list
    when 'user_status' then user_status(info[:status_active])
    end
  end

  private

  def operator_list
    payload = { operators: sorted_operator_list }
    ActionCable.server.broadcast 'operator_channel', payload.to_camelback_keys
  end

  def user_status(status)
    status = %w[available idle away].include?(status) ? status : 'away'
    current_user.user.update_column(:user_status, status)
    ConversationAssignmentManager.reassign_operator_conversations(current_user.user) if status == 'away'
    payload = {
      operator_change: {
        id: current_user.user.id,
        first_name: current_user.user.first_name,
        last_name: current_user.user.last_name,
        status: current_user.user.user_status
      }
    }
    ActionCable.server.broadcast 'operator_channel', payload.to_camelback_keys
  end

  def sorted_operator_list
    User.where.not(user_status: nil)
        .order(first_name: :asc, last_name: :asc)
        .collect do |user|
      {
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        status: user.user_status
      }
    end
  end
end
