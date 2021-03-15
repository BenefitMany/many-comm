<template>
  <div class="org">
    <div class="org__titleContainer dropdown" @click="expandSettings">
      <div class="row-wrapper-c pb-4">
        <h2 class="org__title">
          <img src="/mc_logo.png" class="logo-top-left">
          <span class="align-middle">ManyComm</span>
        </h2>
        <i class="org__settings dropbtn fa fa-cog"/>
      </div>
      <div id="settingsDropdown" class="dropdown__content" @mouseleave="expandSettings">
        <div class="dropdown__header">
          Navigation
        </div>
        <div class="dropdown__body">
          <router-link
            v-for="(navItem, nIndx) in navItems"
            v-show="canSee(navItem.permission)"
            :key="nIndx"
            :to="navItem.route">
            <div class="dropdown__item">
              <i class="dropdown__icon" :class="navItem.icon"/>
              <span>{{ navItem.name }}</span>
            </div>
          </router-link>
          <div class="dropdown__item" @click="resetSession()">
            <i class="dropdown__icon fa fa-sign-out"/>
            <span>Log Out</span>
          </div>
        </div>
      </div>
    </div>

    <div class="org__operator">
      {{ userFullName() }}
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'

export default {
  data () {
    return {
      navItems: [
        {
          name: 'Dashboard',
          icon: 'fa fa-desktop',
          permission: '',
          route: '/dashboard'
        }, {
          name: 'Conversations',
          permission: '',
          route: '/',
          icon: 'fa fa-comments-o'
        }, {
          name: 'Profile',
          permission: '',
          route: 'profile',
          icon: 'fa fa-user'
        }, {
          name: 'Phone Numbers',
          permission: 'admin',
          route: '/phone_numbers',
          icon: 'fa fa-phone'
        }, {
          name: 'Autoresponders',
          permission: 'admin',
          route: '/autoresponders',
          icon: 'fa fa-list-alt'
        },{
          name: 'Chat Access Keys',
          permission: 'admin',
          route: '/chat_access_keys',
          icon: 'fa fa-list-alt'
        }, {
          name: 'Users',
          permission: 'admin',
          route: '/users',
          icon: 'fa fa-users'
        }
      ]
    }
  },

  created () {
    // console.log(this.$store.state)
  },

  methods: {
    ...mapActions('user', ['logout']),
    ...mapGetters('user', ['userFullName', 'permissionCheck', 'companyName']),
    resetSession () {
      this.logout().then(() => {
        this.$router.push({ name: 'login' })
      })
    },

    canSee (route) {
      if (route.length == 0) return true
      return this.$store.getters['user/permissionCheck'](route)
    },

    expandSettings () {
      document.getElementById('settingsDropdown').classList.toggle('show')
    }
  }
}
</script>

<style lang="scss">
@import "~@styles/abstracts/_variables.scss";
.logo-top-left {
  height: 1.75rem;
  width: 1.75rem;
}

.org {
  display: flex;
  flex-direction: column;
}

.org__title {
  margin-right: 12px;
}

.dropdown {
  cursor: pointer;
}

.dropdown__header {
  border-bottom: 1px solid #C9C9C9;
  padding: 0 20px 10px 20px;
  font-size: 1.1rem;
  font-weight: bolder;
}

.dropdown__content {
  display: none;
  position: absolute;
  padding: 14px 0;
  border-radius: 4px;
  color: black;
  background-color: #f9f9f9;
  min-width: 160px;
  z-index: 1;
}

.dropdown__body {
  padding-top: 4px;
}

.dropdown__item {
  display: block;
  padding: 6px 20px;
}

.dropdown__item:hover {
  background-color: $blue;
  color: white;
}

.dropdown__icon {
  font-size: .8rem;
  padding-right: 5px;
}

.show {
  display: flex;
  flex-direction: column;
}
</style>
