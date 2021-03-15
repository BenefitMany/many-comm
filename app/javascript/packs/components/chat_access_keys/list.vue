<template>
  <div>
    <div class="row mt-3">
      <div v-for="accessKey in chatAccessKeys" :key="accessKey.id" class="col-md-6 mb-3">
        <app-access-key :access-key-prop="accessKey" @listAccessKeys="listAccessKeys"/>
      </div>
      <div v-if="chatAccessKeys.length == 0">
        <p>You currently have no chat access keys.</p>
      </div>
    </div>
    <app-common-fab :primary-action-callback="addNewChatAccessKey"/>
  </div>
</template>

<script>
import AccessKey from './access_key.vue'
import CommonFloatingActionButton from '@shared/common_floating_action_button.vue'

export default {
  components: {
    'app-common-fab': CommonFloatingActionButton,
    appAccessKey: AccessKey
  },
  data () {
    return {
      chatAccessKeys: []
    }
  },

  created () {
    this.listAccessKeys()
  },

  methods: {
    addNewChatAccessKey () {
      this.$http.post('/api/chat_access_keys').then(() => {
        this.listAccessKeys()
      }, (responseError) => {
        this.appendError({error: responseError.body.error, notification: true })
      })
    },

    listAccessKeys () {
      this.$http.get('/api/chat_access_keys').then((result) => {
        this.chatAccessKeys = result.data.chatAccessKeys
      }, (responseError) => {
        this.appendError({error: responseError.body.error, notification: true})
      })
    }
  }
}
</script>

<style lang="scss">
</style>
