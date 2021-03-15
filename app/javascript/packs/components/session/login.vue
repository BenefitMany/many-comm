<template>
  <div class="container login-padding-top">
    <app-guest-card :card-title="'Sign In'" :card-icon="'fa-sign-in'">
      <div class="row no-gutters">
        <div class="col-md-12 px-2">
          <label for="login-username">Email address</label>
          <div class="input-group mb-3">
            <input
              v-model="login.email"
              :class="{ 'highlighter-red': $v.login.email.$error }"
              type="text"
              class="form-control"
              placeholder=""
              aria-label="Email Address"
              name="loginUsername"
              required
              aria-describedby="basic-addon2"
              @blur="$v.login.email.$touch()">
            <div class="input-group-append">
              <span id="basic-addon2" class="input-group-text">
                <i class="fa fa-user"/>
              </span>
            </div>
          </div>
        </div>
        <div class="col-md-12 px-2">
          <label for="login-username">Password</label>
          <div class="input-group mb-3">
            <input
              v-model="login.password"
              :class="{ 'highlighter-red': $v.login.password.$error }"
              type="password"
              class="form-control"
              placeholder=""
              aria-label="Password"
              name="loginUsername"
              required
              aria-describedby="basic-addon2"
              @blur="$v.login.password.$touch()"
              @keyup.enter="sendLogin">
            <div class="input-group-append">
              <span id="basic-addon2" class="input-group-text">
                <i class="fa fa-lock"/>
              </span>
            </div>
          </div>
        </div>
      </div>
      <div class="col-md-12 px-2">
        <button class="btn btn-primary float-right" type="submit" @click="sendLogin">
          Sign In
        </button>
      </div>
      <a href="/forgot_password" class="forgot-pass">Forgot Password?</a>
    </app-guest-card>
  </div>
</template>

<script>
import { required, email } from 'vuelidate/lib/validators'
import { mapActions } from 'vuex'
import guestCard from '@shared/guest_card.vue'

export default {
  components: {
    appGuestCard: guestCard
  },
  validations: {
    login: {
      email: { required, email },
      password: { required }
    }
  },
  data () {
    return {
      login: {
        email: '',
        password: ''
      }
    }
  },
  created () {
    if (this.$route.query.url != undefined) {
      this.$router.push(this.$route.query.url)
    }
    if(this.$route.query.unauthorized) {
      this.appendError({ error: 'Unauthorized Request', notification: true })
    }
  },
  methods: {
    ...mapActions('user', ['loadUserSession']),
    sendLogin () {
      this.$v.$touch()
      if (this.$v.$invalid) return

      this.$http.post('/api/login', { login: this.login }).then(() => {
        this.loadUserSession().then(() => {
          this.$router.push({ name: 'dashboard' })
        })
      }).catch(error => {
        this.appendError({ error: error.response.data.error, notification: true })
      })
    }
  }
}
</script>

<style scoped lang="scss">
@import '~@styles/variables.scss';

.logo {
  height: 60px;
}
.login-padding-top {
  padding-top: 10rem;
}
.highlighter-red {
  border: 2px solid red !important;
}
.border-top-apparel {
  border-top: 7px solid $primaryHighlight;
  border-radius: 5px 0px;
}

.primaryHighlight {
  background-color: $primaryHighlight;
  border-radius: 5px 5px 0px 0px;
  color: white;
}
</style>
