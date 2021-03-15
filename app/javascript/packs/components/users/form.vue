<template>
  <div>
    <app-common-messages :messages="appMessages" @resetMessages="resetAppMessages"/>

    <div class="card mt-3">
      <div class="card-body">
        <div class="row">
          <div class="form-group col-sm-6">
            <label>First Name</label>
            <input
              v-model="user.firstName"
              :class="{ 'highlighter-red': $v.user.firstName.$error }"
              type="text"
              class="form-control"
              @blur="$v.user.firstName.$touch()">
          </div>
          <div class="form-group col-sm-6">
            <label>Last Name</label>
            <input
              v-model="user.lastName"
              :class="{ 'highlighter-red': $v.user.lastName.$error }"
              type="text"
              class="form-control"
              @blur="$v.user.lastName.$touch()">
          </div>
        </div>
        <div class="row">
          <div class="form-group col-sm-6">
            <label>Email</label>
            <input
              v-model="user.email"
              :class="{ 'highlighter-red': $v.user.email.$error }"
              type="text"
              class="form-control"
              autocomplete="off"
              @blur="$v.user.email.$touch()">
          </div>
          <div class="form-group col-sm-6">
            <label>Time Zone</label>
            <select v-model="user.timeZone" class="form-control">
              <option value="">
                -- Select --
              </option>
              <option
                v-for="(timeZone, timeZoneIndex) in availableTimeZones"
                :key="timeZoneIndex"
                :value="timeZone">
                {{ timeZone }}
              </option>
            </select>
          </div>
        </div>
        <div class="row">
          <div class="col-sm-6">
            <div class="form-check">
              <input id="adminUser" v-model="user.admin" class="form-check-input" type="checkbox">
              <label class="form-check-label" for="adminUser">
                Admin User
              </label>
            </div>
          </div>
        </div>
        <hr>
        <div class="form-group col-sm-12 text-right">
          Activation link will be sent to email to set password.
        </div>
        <hr>
        <div class="row">
          <div class="col-sm-12 text-right">
            <input v-model="user.id" type="hidden">
            <button type="submit" class="btn btn-default" @click.prevent="redirectToUserList">
              Cancel
            </button>
            <button type="submit" class="btn btn-primary" @click.prevent="saveUser">
              Save
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { required, sameAs, email } from 'vuelidate/lib/validators'
import CommonMessages from '@shared/common_messages.vue'

export default {
  components: {
    appCommonMessages: CommonMessages
  },
  data () {
    return {
      user: {},
      formAction: 'New',
      formButton: 'Save',
      availableTimeZones: [
        'Alaska',
        'Arizona',
        'Central Time',
        'Eastern Time',
        'Mountain Time',
        'Pacific Time'
      ]
    }
  },
  validations: {
    user: {
      firstName: { required },
      lastName: { required },
      email: { required, email },
      timeZone: { required },
      password: {},
      passwordConfirmation: { sameAs: sameAs('password') }
    }
  },

  created () {
    this.resetForm()
    if(this.$route.params.id != undefined ) {
      this.user.id = this.$route.params.id
      this.loadUser()
    }
  },
  methods: {
    saveUser () {
      this.$v.$touch()
      if (this.$v.$invalid) return
      if(this.isBlank(this.user.id)) {
        this.createUser()
      } else {
        this.updateUser()
      }
    },

    createUser () {
      this.$http.post('/api/users', this.formData()).then(() => {
        this.appendSuccess({ message: 'Created user successfully' })
        this.redirectToUserList()
      }).catch(error => {
        this.appendError({ error: error.response.data.error })
      })
    },

    updateUser () {
      this.$http.put(`/api/users/${this.user.id}`, this.formData()).then(() => {
        this.appendSuccess({ message: 'Updated user successfully' })
        this.redirectToUserList()
      }).catch(error => {
        this.appendError({ error: error.response.data.error })
      })
    },

    formData () {
      return {
        user: {
          firstName: this.user.firstName,
          lastName: this.user.lastName,
          admin: this.user.admin,
          email: this.user.email,
          timeZone: this.user.timeZone
        }
      }
    },

    redirectToUserList () {
      this.resetForm()
      this.$router.push({ name: 'userList' })
    },

    resetForm () {
      this.user = {
        id: '',
        firstName: '', lastName: '', email: '', admin: false,
        password: '', passwordConfirmation: '',
        timeZone: ''
      }
      this.$v.$reset()
    },

    loadUser () {
      this.$http.get(`/api/users/${this.user.id}`).then((result) => {
        this.user = result.data.user
        this.formAction = 'Edit'
        this.formButton = 'Update'
      }).catch(error => {
        this.appendError({ error: error.response.data.error })
      })
    }
  }
}
</script>

<style>
</style>
