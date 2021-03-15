<template>
  <div class="container login-padding-top">
    <app-guest-card :card-title="'Update Password'" :card-icon="'fa-pencil-square-o'">
      <div class="row no-gutters">
        <div class="col-md-12 px-2">
          <label for="new-password">New Password</label>
          <div class="input-group mb-3">
            <input
              id="new-password"
              v-model="newPassword"
              :class="{ 'highlighter-red': $v.newPassword.$error }"
              type="password"
              class="form-control"
              placeholder=""
              aria-label="Password"
              name="newPassword"
              required
              aria-describedby="basic-addon2"
              @blur="$v.newPassword.$touch() && $v.newPasswordConfirmation.$touch()">
            <div class="input-group-append">
              <span id="basic-addon2" class="input-group-text">
                <i class="fa fa-lock"/>
              </span>
            </div>
          </div>
        </div>
        <div class="col-md-12 px-2">
          <label for="new-password-confirmation">New Confirmation Password</label>
          <div class="input-group mb-3">
            <input
              id="new-password-confirmation"
              v-model="newPasswordConfirmation"
              :class="{ 'highlighter-red': $v.newPasswordConfirmation.$error }"
              type="password"
              class="form-control"
              placeholder=""
              aria-label="Password"
              name="newPasswordConfirmation"
              required
              aria-describedby="basic-addon2"
              @change="$v.newPasswordConfirmation.$touch()">
            <div class="input-group-append">
              <span id="basic-addon2" class="input-group-text">
                <i class="fa fa-lock"/>
              </span>
            </div>
          </div>
        </div>
      </div>
      <div class="col-md-12 px-2">
        <button class="btn btn-primary float-right" type="submit" @click.prevent="updatePassword()">
          Update Password
        </button>
      </div>
      <div class="w-row">
        <a href="/login" class="forgot-pass">Login?</a>
      </div>
    </app-guest-card>
    <div class="card col-md-4 col-sm-12 order-md-2 order-sm-1 order-1 mx-auto mt-2">
      <div class="card-body">
        <p id="requirements-text" class="card-heading">
          Your password must meet all requirements to continue.
        </p>
        <hr>
        <ul>
          <li>
            <i v-if="!$v.newPassword.required" class="fa fa-times" aria-hidden="true"/>
            <i v-else class="fa fa-check" aria-hidden="true"/>Is required
          </li>
          <li>
            <i v-if="!$v.newPassword.numberMatch" class="fa fa-times" aria-hidden="true"/>
            <i v-else class="fa fa-check" aria-hidden="true"/>At least one number
          </li>
          <li>
            <i v-if="!$v.newPassword.lowerCaseMatch" class="fa fa-times" aria-hidden="true"/>
            <i v-else class="fa fa-check" aria-hidden="true"/>At least one lowercase letter
          </li>
          <li>
            <i v-if="!$v.newPassword.upperCaseMatch" class="fa fa-times" aria-hidden="true"/>
            <i v-else class="fa fa-check" aria-hidden="true"/>At least one uppercase letter
          </li>
          <li>
            <i v-if="!$v.newPassword.lengthMatch" class="fa fa-times" aria-hidden="true"/>
            <i v-else class="fa fa-check" aria-hidden="true"/>At least 8 characters
          </li>
          <li>
            <i v-if="!$v.newPasswordConfirmation.sameAsPassword && $v.newPassword.$dirty" class="fa fa-times" aria-hidden="true"/>
            <i v-else class="fa fa-check" aria-hidden="true"/>Need to match
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
import guestCard from '@shared/guest_card.vue'
import { required, sameAs } from 'vuelidate/lib/validators'

export default {
  components: {
    appGuestCard: guestCard
  },
  data () {
    return {
      token: '',
      newPassword: '',
      newPasswordConfirmation: '',
      error: false
    }
  },
  validations: {
    newPassword: {
      required,
      numberMatch: val => {
        return /.*\d/.test(val)
      },
      lowerCaseMatch: val => {
        return /.*[a-z]/.test(val)
      },
      upperCaseMatch: val => {
        return /.*[A-Z]/.test(val)
      },
      lengthMatch: val => {
        return /.{8,}/.test(val)
      }
    },
    newPasswordConfirmation: {sameAsPassword: sameAs('newPassword')}
  },

  created () {
    this.token = this.$route.params.token
  },
  methods: {
    updatePassword () {
      const params = {
        token: this.token,
        password: this.newPassword,
        passwordConfirmation: this.newPasswordConfirmation
      }
      this.$http.put('/api/forgot_password', params).then(() => {
        this.appendSuccess({message: 'Password Updated', notification: true})
        this.$router.push({ name: 'login' })
      }).catch(error => {
        this.appendError({ error: error.response.data.error, notification: true })
      })
    }
  }
}
</script>

<style scoped lang="scss">
  li {
    text-align: left !important;
    font-size: 14px;
    list-style-type: none;
  }

  ul {
    margin-bottom: 0px;
    margin-left: .7em;
    padding: 0;
  }

  i {
    padding: .2em;
  }

  .fa-times {
    color: red;
  }

  .fa-check {
    color: green;
  }

  #requirements-text {
    margin-top: .5em;
    margin-left: .7em;
  }
</style>
