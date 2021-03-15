<template>
  <div class="container login-padding-top">
    <app-guest-card :card-title="'Forgot Password'" :card-icon="'fa-question-circle'">
      <div class="row no-gutters">
        <div class="col-md-12 px-2">
          <label for="login-username">Email address</label>
          <div class="input-group mb-3">
            <input
              id="forgettenEmail"
              v-model="email"
              :class="{ 'highlighter-red': $v.email.$error }"
              type="text"
              class="form-control"
              placeholder=""
              aria-label="Email Address"
              name="loginUsername"
              required
              aria-describedby="forgettenEmail"
              @blur="$v.email.$touch()">
            <div class="input-group-append">
              <span id="forgettenEmail" class="input-group-text">
                <i class="fa fa-user"/>
              </span>
            </div>
          </div>
        </div>
      </div>
      <div class="col-md-12 px-2">
        <button class="btn btn-primary float-right" type="submit" @click.prevent="sendResetPassword()">
          Reset Password
        </button>
      </div>
      <div class="w-row">
        <a href="/login" class="forgot-pass">Login?</a>
      </div>
    </app-guest-card>
  </div>
</template>

<script>
import guestCard from '@shared/guest_card.vue'
import { required, email } from 'vuelidate/lib/validators'

export default {
  components: {
    appGuestCard: guestCard
  },
  data () {
    return {
      email: '',
      error: false
    }
  },
  validations: {
    email: { required, email }
  },
  methods: {
    sendResetPassword () {
      this.$v.$touch()
      if (this.$v.$invalid) return
      this.$http.post('/api/forgot_password', { email: this.email }).then(() => {
        this.appendSuccess({message: `Reset Password Email Sent to ${this.email}`, notification: true})
        this.$router.push({ name: 'login' })
      }).catch(error => {
        this.appendError({ error: error.response.data.error, notification: true })
      })
    }
  }
}
</script>

<style scoped>
</style>
