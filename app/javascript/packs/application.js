import Vue from 'vue/dist/vue.esm'
import Vuex from 'vuex'
import Vuelidate from 'vuelidate'
import Axios from 'axios'

Vue.use(Vuex)
Vue.use(Vuelidate)

Vue.prototype.$http = Axios


import '@node_modules/bootstrap/dist/js/bootstrap.bundle.min.js'
import '@node_modules/bootstrap/dist/css/bootstrap.min.css'
import '@node_modules/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css'
import '@node_modules/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js'

import '@node_modules/jquery/dist/jquery.slim.min.js'
import '@styles/main.scss'
// import '@styles/theme.scss'

import router from './routes/routes'
import store from './store/store'
import App from './app.vue'

import Mixins from '@shared/mixin.js'
Vue.mixin(Mixins)
import '@shared/filters/filter.js'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#vue_app',
    store,
    router,
    render: h => h(App)
  })
})
