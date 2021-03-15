<template>
  <div>
    <div class="row mt-3">
      <div v-for="responder in autoresponders" :key="responder.id" class="col-md-6 mb-3">
        <app-responder :autoresponder="responder"/>
      </div>
    </div>
  </div>
</template>

<script>
import Responder from './autoresponder.vue'

export default {
  components: {
    appResponder: Responder
  },
  data () {
    return {
      autoresponders: []
    }
  },

  created () {
    this.listAutoresponders()
  },

  methods: {
    listAutoresponders () {
      this.$http.get('/api/autoresponders').then((result) => {
        this.autoresponders = result.data.autoresponders
      }, (responseError) => {
        this.appendError({error: responseError.body.error, notification: true})
      })
    }
  }
}
</script>

<style lang="scss">
</style>
