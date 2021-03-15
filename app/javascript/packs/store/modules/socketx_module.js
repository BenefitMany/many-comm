import SocketX from './socketx.js'

export default {
  namespaced: true,
  state: {
    currentOperatorStatus: '',
    socket: null,
    identifier: ''
  },
  getters: {
    getConversations: (state) => {
      if(state.socket == null) { return }
      return state.socket.socketUserInstance.conversationList()
    },

    getConversationSelectedIdentifier: (state) => {
      if(state.socket == null) { return }
      return state.socket.socketUserInstance.getConversationSelectedIdentifier()
    },

    getCurrentOperatorStatus: (state) => {
      if(state.currentOperatorStatus == '') { return }
      return state.currentOperatorStatus
    }
  },
  mutations: {

    ADD_CONVERSATION_CHANGE_LISTENER: (state, pointerMethod) => {
      state.socket.addConversationChangeListener(pointerMethod)
    },

    ADD_CONVERSATION_LIST_LISTENER: (state, pointerMethod) => {
      state.socket.addConversationListListener(pointerMethod)
    },

    ADD_CONVERSATION_LISTENER: (state, pointerMethod) => {
      state.socket.addConversationNewListener(pointerMethod)
    },

    ADD_CONVERSATION_REMOVE_LISTENER: (state, pointerMethod) => {
      state.socket.addConversationRemoveListener(pointerMethod)
    },

    ADD_CONVERSATION_RESOLVE_LISTENER: (state, pointerMethod) => {
      state.socket.addConversationResolvedListener(pointerMethod)
    },

    ADD_CONVERSATION_SELECTED_NEW_MESSAGE_LISTENER: (state, pointerMethod) => {
      state.socket.addConversationSelectedNewMessageListener(pointerMethod)
    },

    ADD_CONVERSATION_UNRESOLVED_LISTENER: (state, pointerMethod) => {
      state.socket.addConversationUnresolvedListener(pointerMethod)
    },

    ADD_MESSAGES_LIST_LISTENER: (state, pointerMethod) => {
      state.socket.addMessageListListener(pointerMethod)
    },

    ADD_MESSAGE_NEW_LISTENER: (state, pointerMethod) => {
      state.socket.addMessageNewListener(pointerMethod)
    },

    ADD_OPERATORS_LISTENER: (state, pointerMethod) => {
      state.socket.addOperatorsListener(pointerMethod)
    },

    ADD_OPERATOR_CHANGE_LISTENER: (state, pointerMethod) => {
      state.socket.addOperatorChangeListener(pointerMethod)
    },

    GET_MESSAGES: (state) => {
      state.socket.socketUserInstance.messageList()
    },

    REMOVE_SOCKET (state) {
      state.identifier = ''
      if(state.socket) {
        state.socket.disconnect()
      }
      state.socket = null
      console.log('Socket closed')
    },

    SET_CONVERSATION_RESOLVED: (state) => {
      state.socket.socketUserInstance.conversationResolved()
    },

    SET_CONVERSATION_UNRESOLVED: (state) => {
      state.socket.socketUserInstance.conversationUnresolved()
    },

    SEND_MESSAGE: (state, message) => {
      state.socket.socketUserInstance.sendMessage(message)
    },

    SET_SOCKET_IDENTIFIER (state, identifier) {
      if(state.socket != null) { return }
      // console.log('SET_SOCKET_IDENTIFIER', identifier)
      state.identifier = identifier
      state.socket = new SocketX(state.identifier)
    },

    SET_SOCKET (state) {
      if(state.socket != null || state.identifier != '') { return }
      state.socket = new SocketX(state.identifier)
    },

    SET_CONVERSATION_SELECTED_IDENTIFIER: (state, conversationIdentifier) => {
      state.socket.socketUserInstance.setConversationSelectedIdentifier(conversationIdentifier)
    },

    SET_USER_STATUS: (state, statusActive) => {
      state.currentOperatorStatus = statusActive
      state.socket.socketOperatorInstance.setUserStatus(statusActive)
    }
  },
  actions: {
    addConversationChangeListener: ({commit}, pointerMethod) => {
      commit('SET_SOCKET')
      commit('ADD_CONVERSATION_CHANGE_LISTENER', pointerMethod)
    },

    addConversationListListener: ({commit}, pointerMethod) => {
      commit('SET_SOCKET')
      commit('ADD_CONVERSATION_LIST_LISTENER', pointerMethod)
    },

    addConversationNewListener: ({commit}, pointerMethod) => {
      commit('SET_SOCKET')
      commit('ADD_CONVERSATION_LISTENER', pointerMethod)
    },

    addConversationRemoveListener: ({commit}, pointerMethod) => {
      commit('SET_SOCKET')
      commit('ADD_CONVERSATION_REMOVE_LISTENER', pointerMethod)
    },

    addMessagesListListener: ({commit}, pointerMethod) => {
      commit('SET_SOCKET')
      commit('ADD_MESSAGES_LIST_LISTENER', pointerMethod)
    },

    addMessageNewListener: ({commit}, pointerMethod) => {
      commit('SET_SOCKET')
      commit('ADD_MESSAGE_NEW_LISTENER', pointerMethod)
    },

    addConversationResolvedListener: ({commit}, pointerMethod) => {
      commit('SET_SOCKET')
      commit('ADD_CONVERSATION_RESOLVE_LISTENER', pointerMethod)
    },

    addConversationSelectedNewMessageListener: ({commit}, pointerMethod) => {
      commit('SET_SOCKET')
      commit('ADD_CONVERSATION_SELECTED_NEW_MESSAGE_LISTENER', pointerMethod)
    },

    addConversationUnresolvedListener: ({commit}, pointerMethod) => {
      commit('SET_SOCKET')
      commit('ADD_CONVERSATION_UNRESOLVED_LISTENER', pointerMethod)
    },

    addOperatorsListener: ({commit}, pointerMethod) => {
      commit('SET_SOCKET')
      commit('ADD_OPERATORS_LISTENER', pointerMethod)
    },

    addOperatorChangeListener: ({commit}, pointerMethod) => {
      commit('SET_SOCKET')
      commit('ADD_OPERATOR_CHANGE_LISTENER', pointerMethod)
    },

    conversationResolved: ({commit}) => {
      commit('SET_SOCKET')
      commit('SET_CONVERSATION_RESOLVED')
    },
    conversationUnresolved: ({commit}) => {
      commit('SET_SOCKET')
      commit('SET_CONVERSATION_UNRESOLVED')
    },

    getMessages: ({commit}) => {
      commit('SET_SOCKET')
      commit('GET_MESSAGES')
    },

    setConversationSelectedIdentifier: ({ commit }, conversationIdentifier) => {
      commit('SET_SOCKET')
      commit('SET_CONVERSATION_SELECTED_IDENTIFIER', conversationIdentifier)
    },

    sendMessage: ({commit}, message) => {
      commit('SET_SOCKET')
      commit('SEND_MESSAGE', message)
    },

    setUserStatus: ({commit}, statusActive) => {
      commit('SET_SOCKET')
      commit('SET_USER_STATUS', statusActive)
    }
  }
}