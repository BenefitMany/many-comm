<template>
  <div class="card gsni-top-border p-3">
    <app-common-messages :messages="appMessages" @resetMessages="resetAppMessages"/>

    <header class="row d-flex align-items-center">
      <div class="col-sm-6">
        <h1 class="h3 display">
          Profile
        </h1>
      </div>
    </header>
    <form>
      <div class="row">
        <div class="col-sm-6">
          <div class="form-group">
            <label>First Name</label>
            <input
              v-model="profile.firstName"
              :class="{ 'highlighter-red': $v.profile.firstName.$error }"
              type="text"
              class="form-control"
              aria-describedby="First Name">
            <p v-if="!$v.profile.firstName.required" class="vuelidate-message">
              * First name is required
            </p>
          </div>
        </div>
        <div class="col-sm-6">
          <div class="form-group">
            <label>Last Name</label>
            <input
              v-model="profile.lastName"
              :class="{ 'highlighter-red': $v.profile.lastName.$error }"
              type="text"
              class="form-control"
              aria-describedby="Last Name">
            <p v-if="!$v.profile.lastName.required" class="vuelidate-message">
              * Last name is required
            </p>
          </div>
        </div>
        <div class="col-sm-6">
          <div class="form-group">
            <label>Current Email</label>
            <input
              v-model="profile.email"
              type="text"
              class="form-control"
              aria-describedby="Email"
              disabled>
          </div>
        </div>
        <div class="col-sm-6">
          <div class="form-group">
            <label>New Email</label>
            <input
              v-model="profile.newEmail"
              :class="{ 'highlighter-red': $v.profile.newEmail.$error }"
              type="text"
              class="form-control"
              aria-describedby="New Email">
          </div>
        </div>
      </div>

      <hr>

      <div class="row">
        <div class="form-group col-sm-6">
          <label>Time Zone</label>
          <select v-model="profile.timeZone" class="form-control">
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

      <hr>

      <div class="row">
        <div class="col-sm-6">
          <div class="form-group">
            <label for="new-password">New Password</label>
            <input
              id="new-password"
              v-model="profile.password"
              :class="{ 'highlighter-red': $v.profile.password.$error }"
              type="password"
              class="form-control"
              aria-describedby="New Password"
              @blur="$v.profile.password.$touch()">
            <ul>
              <li v-if="!$v.profile.password.numberMatch" class="vuelidate-message">
                Needs to contain at least one number
              </li>
              <li v-if="!$v.profile.password.lowerCaseMatch" class="vuelidate-message">
                Needs to contain at least one lowercase letter
              </li>
              <li v-if="!$v.profile.password.upperCaseMatch" class="vuelidate-message">
                Needs to contain at least one uppercase letter
              </li>
              <li v-if="!$v.profile.password.lengthMatch" class="vuelidate-message">
                Needs to contain at least 8 characters
              </li>
            </ul>
          </div>
        </div>
        <div class="col-sm-6">
          <div class="form-group">
            <label for="new-password-confirmation">New Password Confirmation</label>
            <input
              id="new-password-confirmation"
              v-model="profile.passwordConfirmation"
              :class="{ 'highlighter-red': $v.profile.passwordConfirmation.$error }"
              type="password"
              class="form-control"
              aria-describedby="New Password Confirmation"
              @blur="$v.profile.passwordConfirmation.$touch()">
            <p v-if="!$v.profile.passwordConfirmation.sameAsPassword && $v.profile.password.$dirty" class="vuelidate-message">
              Passwords do not match
            </p>
          </div>
        </div>
      </div>

      <div class="row">
        <div class="col-sm-12 text-right">
          <button type="submit" class="btn btn-primary" @click.prevent="updateProfile">
            Update
          </button>
        </div>
      </div>
    </form>
  </div>
</template>

<script>
import { required, email, sameAs } from 'vuelidate/lib/validators'
import CommonMessages from '@shared/common_messages.vue'

export default {
  components: {
    'app-common-messages': CommonMessages
  },
  data () {
    return {
      profile: {},
      selectedAvatar: null,
      removeAvatar: false,
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
    profile: {
      email: { required, email },
      firstName: { required },
      lastName: { required },
      newEmail: { email },
      password: {
        numberMatch: val => {
          if (val) {
            return /.*\d/.test(val)
          }
          else return true
        },
        lowerCaseMatch: val => {
          if(val) {
            return /.*[a-z]/.test(val)
          }
          else return true
        },
        upperCaseMatch: val => {
          if(val) {
            return /.*[A-Z]/.test(val)
          }
          else return true
        },
        lengthMatch: val => {
          if (val) {
            return /.{8,}/.test(val)
          }
          else return true
        }
      },
      passwordConfirmation: {
        sameAsPassword: sameAs('password')
      }
    }
  },

  created () {
    this.loadProfile()
  },
  methods: {
    confirmRemoveProfileImage () {
      $('#confirm-remove-profile-image-modal').modal('show')
    },

    updateProfile () {
      this.$v.$touch()
      if (this.$v.$invalid) return
      this.updateprofile()
    },

    updateprofile () {
      const fdStatus = {
        onUploadProgress: uploadEvent => { // eslint-disable-line no-unused-vars
          console.log('Upload Progress: ' + Math.round(uploadEvent.loaded / uploadEvent.total * 100) + '%')
        }
      }

      this.$http.put('/api/profile', this.formData(), fdStatus).then(() => {
        this.appendSuccess({ message: 'You have successfully updated your profile!' })
        this.$v.$reset()
      }).catch(error => {
        this.appendError({ error: error.response.data.error })
      })
    },

    formData () {
      const fd = new FormData()
      fd.append('profile[firstName]', this.profile.firstName)
      fd.append('profile[lastName]', this.profile.lastName)
      fd.append('profile[timeZone]', this.profile.timeZone)
      if(!this.isBlank(this.profile.newEmail)) {
        fd.append('profile[newEmail]', this.profile.newEmail)
      }
      if(!this.isBlank(this.profile.password) || !this.isBlank(this.profile.passwordConfirmation)) {
        fd.append('profile[password]', this.profile.password)
        fd.append('profile[passwordConfirmation]', this.profile.passwordConfirmation)
      }
      return fd
    },

    loadProfile () {
      this.$http.get('/api/profile').then((result) => {
        this.profile = result.data.profile
        this.profile.newEmail = '' // Initialize to blank
      }).catch(error => {
        this.appendError({ error: error.response.data.error })
      })
    }
  }
}
</script>

<style scoped>
  /* #avatar-file-image {
    width: 200px;
    height: 200px;
  } */
</style>
