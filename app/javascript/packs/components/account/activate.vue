<template>
  <div class="container login-padding-top">
    <div class="row no-gutters">
      <div class="col-md-5 mx-auto">
        <app-common-messages :messages="appMessages" @resetMessages="resetAppMessages"/>
      </div>
    </div>
    <app-guest-card :card-title="'Activate Account'">
      <div v-if="showSuccessForm" class="col-md-10 mx-auto">
        <div>
          Your account has been activated.
          <br>
          Please set your password.
        </div>
        <br>
        <router-link
          :to="{ name: 'updatePassword', params: { token: token }}"
          tag="button"
          class="btn btn-gsni col-md-12 br-25">
          Set Password -->
        </router-link>
      </div>

      <div v-else-if="showFailureForm" class="input-group mb-3">
        <div>
          Your account could not be activated.
          <br>
          Please try clicking the link you received again.
        </div>
      </div>

      <div v-else class="input-group mb-3">
        <div>
          Searching for account ....
        </div>
      </div>
    </app-guest-card>
  </div>
</template>

<script>
import guestCard from '@shared/guest_card.vue'
import CommonMessages from '@shared/common_messages.vue'

export default {
  components: {
    appGuestCard: guestCard,
    appCommonMessages: CommonMessages
  },
  data () {
    return {
      token: '',
      showForm: 0
    }
  },
  computed: {
    showSuccessForm () {
      return this.showForm == 1
    },

    showFailureForm () {
      return this.showForm == 2
    }
  },

  created () {
    this.token = this.$route.params.token
    this.activateAccount()
  },
  methods: {
    activateAccount () {
      this.$http.get(`/api/account/${this.token}/activate`).then(() => {
        this.showForm = 1
      }, () => {
        this.showForm = 2
      })
    }
  }
}
</script>

<style scoped>
</style>
