import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'
import createPersistedState from 'vuex-persistedstate'
import socketModule from './modules/socketx_module.js'
import userModule from './modules/user_module.js'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    notificationMessages: {
      successes: [],
      errors: []
    }
  },
  getters: {
    notificationErrors: (state) => {
      return state.notificationMessages.errors
    },
    notificationSuccesses: (state) => {
      return state.notificationMessages.successes
    }
  },
  mutations: {
    ADD_NOTIFICATION_ERRORS: (state, payload) => {
      state.notificationMessages.errors.push(payload)
    },
    ADD_NOTIFICATION_SUCCESSES: (state, payload) => {
      state.notificationMessages.successes.push(payload)
    },
    REMOVE_NOTIFICATION_ERROR_BY_INDX: (state, payload) => {
      state.notificationMessages.errors.splice(payload, 1)
    },
    REMOVE_NOTIFICATION_SUCCESS_BY_INDX: (state, payload) => {
      state.notificationMessages.successes.splice(payload, 1)
    },
    RESET_NOTIFICATION_MESSAGES: (state) => {
      state.notificationMessages.errors = []
      state.notificationMessages.successes = []
    }
  },
  actions: {
    resetNotificationMessages: ({commit}) => {
      commit('RESET_NOTIFICATION_MESSAGES')
    },
    spliceNotificationError: ({commit}, payload) => {
      commit('REMOVE_NOTIFICATION_ERROR_BY_INDX', payload)
    },
    spliceNotificationSuccess: ({commit}, payload) => {
      commit('REMOVE_NOTIFICATION_SUCCESS_BY_INDX', payload)
    },
    setNotificationErrors: ({commit}, payload) => {
      commit('ADD_NOTIFICATION_ERRORS', payload)
      setTimeout(() => {
        commit('REMOVE_NOTIFICATION_ERROR_BY_INDX', 0)
      }, 7000)
    },
    setNotificationSuccesses: ({commit}, payload) => {
      commit('ADD_NOTIFICATION_SUCCESSES', payload)
      setTimeout(() => {
        commit('REMOVE_NOTIFICATION_SUCCESS_BY_INDX', 0)
      }, 7000)
    }
  },
  modules: {
    socketx: socketModule,
    user: userModule
  },
  plugins: [createPersistedState({
    paths: [
      'user.user',
      'user.permissions',
      'user.settings',
      'user.userAuthenticated'
    ]
  })]
})

export default store
