import { EventBus } from '@shared/event-bus.js'
export default class SocketX {
  constructor (userIdentifier) {
    // console.log('SocketX constructor started')
    this.userIdentifier = userIdentifier

    // App.startActionCable()

    this.disconnect = () => {
      // eslint-disable-next-line no-undef
      App.cable.subscriptions.consumer.disconnect()
      // eslint-disable-next-line no-undef
      App.cable.subscriptions.remove(this.socketOperatorInstance)
      // eslint-disable-next-line no-undef
      App.cable.subscriptions.remove(this.socketUserInstance)
    }

    // eslint-disable-next-line no-undef
    this.socketOperatorInstance = App.cable.subscriptions.create(
      {
        channel: 'OperatorChannel'
      },
      {
        // Socket methods
        connected: this._operatorChannelConnected,
        disconnected: this._operatorChannelDisconnected,
        away: this._operatorChannelAway,
        received: this._operatorChannelReceived,
        // speak: this._speak,

        // Server methods for operators
        operatorList: this._operatorList,
        setUserStatus: this._setUserStatus,

        // Listeners
        listeners: {
          operators: new Set(),
          operatorChange: new Set()
        }
      }
    )

    // eslint-disable-next-line no-undef
    this.socketUserInstance = App.cable.subscriptions.create(
      {
        channel: 'UserChannel'
      },
      {
        // Socket methods
        connected: this._userChannelConnected,
        disconnected: this._userChannelDisconnected,
        away: this._userChannelAway,
        received: this._userChannelReceived,
        // speak: this._speak,

        // Conversation selection
        selectedConversationIdentifier: null,
        getConversationSelectedIdentifier: this._getConversationSelectedIdentifier,
        setConversationSelectedIdentifier: this._setConversationSelectedIdentifier,

        // Server methods for converation/messages
        conversationList: this._conversationList,
        messageList: this._messageList,
        sendMessage: this._sendMessage,
        conversationResolved: this._conversationResolved,
        conversationUnresolved: this._conversationUnresolved,

        // Helper methods
        conversationMobileLookup: {},
        updateConversationMobileLookup: this._updateConversationMobileLookup,
        checkSelectedConversationMobile: this._checkSelectedConversationMobile,

        // Listeners
        listeners: {
          conversations: new Set(),
          conversationChange: new Set(),
          messages: new Set(),
          newConversation: new Set(),
          newMessage: new Set(),
          removeConversation: new Set(),
          resolvedConversation: new Set(),
          selectedConversationNewMessage: new Set(),
          unresolvedConversation: new Set()
        }
      }
    )

    // console.log('SocketX constructor completed')
  }

  /*
   * #############################################################
   * Operator Channel Methods
   * #############################################################
   */

  _operatorChannelAway () {
    // console.log('From many_com :: OperatorChannel away')
  }

  _operatorChannelConnected () {
    // console.log('From many_com :: OperatorChannel connected')
    this.operatorList()
  }

  _operatorChannelDisconnected () {
    // console.log('From many_com :: OperatorChannel disconnected')
  }

  _operatorChannelReceived (data) {
    if (data.operators) {
      this.listeners.operators.forEach((listener) => listener(data.operators))
    } else if (data.operatorChange) {
      this.listeners.operatorChange.forEach((listener) => listener(data.operatorChange))
    } else {
      // console.log('OPERATOR CHANNEL DATA IGNORED:', data)
    }
  }

  _operatorList () {
    this.perform('speak', { method: 'operator_list' })
  }

  addOperatorsListener (pointerMethod) {
    this.socketOperatorInstance.listeners.operators.add(pointerMethod)
    this.socketOperatorInstance.operatorList()
    /*
     * console.log('addOperatorsListener', pointerMethod)
     * console.log('addOperatorsListener', this.socketOperatorInstance.listeners.operators)
     */
  }

  addOperatorChangeListener (pointerMethod) {
    this.socketOperatorInstance.listeners.operatorChange.add(pointerMethod)
  }

  /*
   * #############################################################
   * User Channel Methods
   * #############################################################
   */

  _checkSelectedConversationMobile () {
    return this.conversationMobileLookup[this.selectedConversationIdentifier]
  }

  _conversationList () {
    this.perform('speak', { method: 'conversation_list' })
  }

  _conversationResolved () {
    this.perform('speak', { method: 'resolve_conversation', conversationIdentifier: this.selectedConversationIdentifier })
  }

  _getConversationSelectedIdentifier () {
    return this.selectedConversationIdentifier
  }

  _messageList () {
    // console.log('To many_com :: UserChannel messageList', this.selectedConversationIdentifier)
    if(this.selectedConversationIdentifier == null) { return }
    // console.log('To many_com :: UserChannel messageList', selectedConversationIdentifier)
    this.perform('speak', { method: 'message_list', conversationIdentifier: this.selectedConversationIdentifier })
  }

  _sendMessage (message) {
    this.perform('speak', {
      method: 'new_message',
      conversationIdentifier: this.selectedConversationIdentifier,
      message: message
    })
    // EventBus.$emit('playSoundNotification', 'sent') TODO: Add sound settings later
  }

  _setConversationSelectedIdentifier (identifier) {
    this.selectedConversationIdentifier = identifier
    this.listeners.conversationChange.forEach((listener) => listener())
  }

  _setUserStatus (statusActive) {
    this.perform('speak', { method: 'user_status', statusActive: statusActive })
  }

  _updateConversationMobileLookup (conversations) {
    conversations.forEach((con) => {
      this.conversationMobileLookup[con.identifier] = con.mobile
    })
  }

  _userChannelAway () {
    // console.log('From many_com :: UserChannel away')
  }

  _userChannelConnected () {
    // console.log('From many_com :: UserChannel connected')
    this.conversationList()
  }

  _userChannelDisconnected () {
    // console.log('From many_com :: UserChannel disconnected')
  }

  _userChannelReceived (data) {
    // console.log('data', data)
    if (data.conversations) {
      this.listeners.conversations.forEach((listener) => listener(data.conversations))
      this.updateConversationMobileLookup(data.conversations)
    } else if (data.newConversation) {
      EventBus.$emit('playSoundNotification', 'received')
      this.listeners.newConversation.forEach((listener) => listener(data.newConversation))
      this.updateConversationMobileLookup([data.newConversation])
    } else if (data.removeConversation) {
      this.listeners.removeConversation.forEach((listener) => listener(data.removeConversation))
      delete this.conversationMobileLookup[data.removeConversation.identifier]
    } else if (data.resolvedConversation) {
      this.listeners.resolvedConversation.forEach((listener) => listener(data.resolvedConversation))
    } else if (data.messageList) {
      this.listeners.messages.forEach((listener) => listener(data.messageList))
    } else if (data.newMessage) {
      EventBus.$emit('playSoundNotification', 'received')
      this.listeners.newMessage.forEach((listener) => listener(data.newMessage))
      if(this.selectedConversationIdentifier == data.newMessage.conversationIdentifier) {
        this.listeners.selectedConversationNewMessage.forEach((listener) => listener(data.newMessage))
      }
    } else if (data.resolvedConversation) {
      this.listeners.resolvedConversation.forEach((listener) => listener(data.resolvedConversation))
    } else if (data.unresolvedConversation) {
      this.listeners.unresolvedConversation.forEach((listener) => listener(data.unresolvedConversation))
    } else {
      console.log('USER CHANNEL DATA IGNORED:', data)
    }
  }

  _conversationUnresolved () {
    this.perform('speak', { method: 'unresolve_conversation', conversationIdentifier: this.selectedConversationIdentifier })
  }

  addConversationChangeListener (pointerMethod) {
    this.socketUserInstance.listeners.conversationChange.add(pointerMethod)
  }

  addConversationListListener (pointerMethod) {
    this.socketUserInstance.listeners.conversations.add(pointerMethod)
    this.socketUserInstance.conversationList()
  }

  addConversationNewListener (pointerMethod) {
    this.socketUserInstance.listeners.newConversation.add(pointerMethod)
  }

  addConversationRemoveListener (pointerMethod) {
    this.socketUserInstance.listeners.removeConversation.add(pointerMethod)
  }

  addMessageListListener (pointerMethod) {
    this.socketUserInstance.listeners.messages.add(pointerMethod)
  }

  addMessageNewListener (pointerMethod) {
    this.socketUserInstance.listeners.newMessage.add(pointerMethod)
  }

  addConversationResolvedListener (pointerMethod) {
    this.socketUserInstance.listeners.resolvedConversation.add(pointerMethod)
  }

  addConversationSelectedNewMessageListener (pointerMethod) {
    this.socketUserInstance.listeners.selectedConversationNewMessage.add(pointerMethod)
  }

  addConversationUnresolvedListener (pointerMethod) {
    this.socketUserInstance.listeners.unresolvedConversation.add(pointerMethod)
  }
}
