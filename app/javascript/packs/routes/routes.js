import ActivateAccount from '@components/account/activate.vue'
import AutorespondersList from '@components/autoresponders/list.vue'
import ChatAccessKeyList from '@components/chat_access_keys/list.vue'
import Dashboard from '@components/dashboard/show.vue'
import ForgotPassword from '@components/session/forgot_password.vue'
import Messages from '@components/messages/messages.vue'
import PhoneNumberShow from '@components/phone_numbers/show.vue'
import Profile from '@components/profile/show.vue'
import SessionLogin from '@components/session/login.vue'
import UpdatePassword from '@components/session/update_password.vue'
import UserForm from '@components/users/form.vue'
import UserList from '@components/users/list.vue'

import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'
import store from '../store/store'

Vue.use(VueRouter)

const routes = [
  {
    path: '/login',
    component: SessionLogin,
    name: 'login',
    meta: { displayName: 'Login', guestView: true }
  },{
    path: '/account/:token/activate',
    component: ActivateAccount,
    name: 'activateAccount',
    meta: { displayName: 'Account Activation', guestView: true }
  },{
    path: '/forgot_password',
    component: ForgotPassword,
    name: 'forgotPassword',
    meta: { displayName: 'Forgot Password', guestView: true }
  },{
    path: '/update_password/:token',
    component: UpdatePassword,
    name: 'updatePassword',
    meta: { displayName: 'Update Password', guestView: true }
  }, {
    path: '/',
    component: Messages,
    name: 'messages',
    meta: { displayName: 'Messages', noContainer: true }
  }, {
    path: '/dashboard',
    component: Dashboard,
    name: 'dashboard',
    meta: { displayName: 'Dashboard' }
  },{
    path: '/profile',
    component: Profile,
    name: 'profile',
    meta: { displayName: 'Profile' }
  },{
    path: '/phone_numbers',
    component: PhoneNumberShow,
    name: 'phoneNumberList',
    meta: { displayName: 'Phone Numbers' }
  },{
    path: '/autoresponders',
    component: AutorespondersList,
    name: 'autorespondersList',
    meta: { displayName: 'Autoresponders' }
  },{
    path: '/chat_access_keys',
    component: ChatAccessKeyList,
    name: 'chatAccessKeyList',
    meta: { displayName: 'Chat Access Keys' }
  },{
    path: '/users',
    component: UserList,
    name: 'userList',
    meta: { displayName: 'Users' }
  },{
    path: '/users/new',
    component: UserForm,
    name: 'userNew',
    meta: { displayName: 'New User' }
  },{
    path: '/users/:id/edit',
    component: UserForm,
    name: 'userEdit',
    meta: { displayName: 'Edit User' }
  }
]

const router = new VueRouter({
  routes,
  mode: 'history',
  scrollBehavior: function (to, from, savedPosition) { // eslint-disable-line no-unused-vars
    if (to.hash) {
      return { selector: to.hash }
    } else {
      return { x: 0, y: 0 }
    }
  }
})

router.beforeEach((to, from, next) => {
  if (to.query.url != undefined) {
    next(to.query.url)
  } else if (to.matched.some(route => route.meta.guestView)) {
    next()
  } else {
    if(store.getters['user/userAuthenticated']) {
      next()
    } else {
      next({ name: 'login' })
    }
  }
})


export default router
