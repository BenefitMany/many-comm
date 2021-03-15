<template>
  <div id="manycomm_app">
    <app-common-notifications/>
    <div v-if="userAuthenticated()" class="appWrapper">
      <app-sidebar/>
      <router-view :class="[ $route.meta.noContainer ? '' : 'routerViewContainer' ]"/>
    </div>

    <div v-else>
      <div class="page login-page">
        <router-view/>
      </div>
    </div>
    <div id="sound"/>
  </div>
</template>

<script>
import Sidebar from './components/sidebar/sidebar.vue'
import CommonNotifications from '@shared/common_notifications.vue'
import { mapGetters, mapActions } from 'vuex'
import { EventBus } from '@shared/event-bus.js'

export default {
  components: {
    'app-common-notifications': CommonNotifications,
    appSidebar: Sidebar
  },
  mounted () {
    const self = this
    window.onbeforeunload = function (e) { // eslint-disable-line no-unused-vars
      e = e || window.event
      self.logout()
      return 'Sure?'
    }
    this.loadUserSession()
    EventBus.$on('playSoundNotification', soundName => {
      this.playSound(soundName)
    })
  },
  methods: {
    ...mapGetters('user', ['userAuthenticated']),
    ...mapActions('user', ['loadUserSession', 'logout']),
    playSound (soundName = 'sent') {
      const mp3Source = '<source src="/sound_files/' + soundName + '.mp3" type="audio/mpeg">'
      const oggSource = '<source src="/sound_files/' + soundName + '.ogg" type="audio/ogg">'
      const embedSource = '<embed hidden="true" autostart="true" loop="false" src="/sound_files/' + soundName +'.mp3">'
      document.getElementById('sound').innerHTML='<audio autoplay="autoplay">' + mp3Source + oggSource + embedSource + '</audio>'
    }
  }
}
</script>

<style scoped lang="scss">

</style>
