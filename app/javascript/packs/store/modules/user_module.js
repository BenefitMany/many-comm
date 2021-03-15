import Axios from 'axios'

function initialState () {
  return {
    settings: {},
    user: {},
    permissions: [],
    userAuthenticated: false
  }
}

export default {
  namespaced: true,
  state: {
    ...initialState()
  },
  getters: {
    userAuthenticated: (state) => {
      return state.userAuthenticated
    },
    permissionCheck: (state) => (permName) => {
      if(state.permissions == undefined) { return false }
      return state.permissions.find((perm) => perm.toLowerCase().replace(/ +/g, '-') == permName)
    },
    userFullName: (state) => {
      if(state.user == {}) { return '' }
      return [state.user.firstName, state.user.lastName].join(' ')
    },
    companyName: (state) => {
      if(state.user == {}) { return '' }
      return state.user.companyName
    }
  },
  mutations: {
    RESET_STATE (state) {
      // acquire initial state
      const s = initialState()
      Object.keys(s).forEach(key => {
        state[key] = s[key]
      })
    },

    SET_SESSION_INFO: (state, payload) => {
      state.user = payload
      state.permissions = state.user.admin ? ['admin'] : []
      delete state.user.permissions
      state.userAuthenticated = payload.userId != undefined
    }
  },

  actions: {
    loadUserSession: ({ commit }) => {
      return new Promise((resolve, reject) => {
        Axios.get('/api/me').then((response) => {
          if(Object.keys(response.data).length === 0) {
            resolve()
          } else {
            commit('SET_SESSION_INFO', response.data)
            commit('socketx/SET_SOCKET_IDENTIFIER', response.data.identifier, { root: true })
            resolve(response.data)
          }
        }).catch(error => {
          reject(error)
        })
      })
    },

    logout: ({ commit }) => {
      return new Promise((resolve, reject) => {
        Axios.delete('/api/logout').then(() => {
          commit('socketx/REMOVE_SOCKET', null, { root: true })
          commit('RESET_STATE')
          resolve()
        }).catch(error => {
          console.log(error)
          reject(error)
        })
      })
    }
  }
}
