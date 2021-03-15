<template>
  <div>
    <div class="row mt-3">
      <div v-for="phoneNumber in phoneNumbers" :key="phoneNumber.id" class="col-md-6">
        <app-common-delete :delete-object="phoneNumber" :unique-identifier="phoneNumber.id+'phone'" :confirm-delete-callback="removePhoneNumber"/>
        <div class="card">
          <div class="card-header">
            <span class="text-muted">Name:</span> {{ phoneNumber.name }}
            <i
              :data-target="'#delete-modal-'+phoneNumber.id+'phone'"
              class="fa fa-fw fa-trash"
              data-toggle="modal"/>
            <span v-show="!phoneNumber.editable" class="float-right cursor-hand ml-3" @click="editPhoneNumber(phoneNumber)">
              Delete
              <i class="fa fa-trash"/>
            </span>
            <span v-show="!phoneNumber.editable" class="float-right cursor-hand" @click="editPhoneNumber(phoneNumber)">
              Edit
              <i class="fa fa-pencil"/>
            </span>
          </div>
          <div v-show="!phoneNumber.editable" class="card-body">
            <div class="pt-1">
              <span class="text-muted">Number:</span>
              <br>
              {{ phoneNumber.number }}
            </div>
            <div>
              {{ phoneNumber.statusChangedAt | dateMMDDYYHHMM }}
            </div>
          </div>
          <div v-show="phoneNumber.editable" class="card-body row no-gutters">
            <div class="form-group col-md-12">
              <label for="phoneNumberMessage" class="text-muted">Name:</label>
              <input
                id="phoneNumberMessage"
                v-model="selectedPhoneNumber.name"
                :class="{ 'highlighter-red': $v.selectedPhoneNumber.name.$error }"
                type="text"
                class="form-control"
                @blur="$v.selectedPhoneNumber.name.$touch()">
            </div>
            <div class="col-sm-12 text-right">
              <button class="btn btn-secondary" @click.prevent="editPhoneNumber(phoneNumber)">
                Cancel
              </button>
              <button type="submit" class="btn btn-primary" @click.prevent="updatePhoneNumber(phoneNumber)">
                Save
              </button>
            </div>
          </div>
        </div>
      </div>
      <div v-show="newPhone.active" class="col-md-6">
        <div class="card">
          <div class="card-body row no-gutters">
            <div class="form-group col-md-12">
              <label for="newPhoneNumberMessage" class="text-muted">Name:</label>
              <input
                id="newPhoneNumberMessage"
                v-model="newPhone.name"
                :class="{ 'highlighter-red': $v.newPhone.name.$error }"
                type="text"
                class="form-control"
                @blur="$v.newPhone.name.$touch()">
            </div>
            <div class="form-group col-md-12">
              <label for="newPhoneNumber" class="text-muted">Number:</label>
              <input
                id="newPhoneNumber"
                v-model="newPhone.number"
                :class="{ 'highlighter-red': $v.newPhone.number.$error }"
                type="text"
                class="form-control"
                @blur="$v.newPhone.number.$touch()">
            </div>
            <div class="col-sm-12 text-right">
              <button class="btn btn-secondary" @click.prevent="resetNewPhone">
                Cancel
              </button>
              <button type="submit" class="btn btn-primary" @click.prevent="createPhoneNumber(newPhone)">
                Save
              </button>
            </div>
          </div>
        </div>
      </div>
      <div v-if="phoneNumbers.length == 0 && !newPhone.active">
        <p>You currently have no phone numbers attached to your account.</p>
      </div>
    </div>
    <app-common-fab :primary-action-callback="addNewPhone"/>
  </div>
</template>

<script>
import CommonDelete from '@shared/common_delete.vue'
import CommonFloatingActionButton from '@shared/common_floating_action_button.vue'
import { required } from 'vuelidate/lib/validators'

export default {
  components: {
    'app-common-delete': CommonDelete,
    'app-common-fab': CommonFloatingActionButton
  },
  data () {
    return {
      tableColumns: [
        'name',
        { rowOptions: true }
      ],
      phoneNumbers: [],
      selectedPhoneNumber: {
        name: ''
      },
      newPhone: {
        active: false,
        name: '',
        number: ''
      },
      meta: {},
      tableParams: { page: 1, perPage: 25, search: '', sort: null, order: null }
    }
  },

  validations: {
    selectedPhoneNumber: {
      name: { required }
    },
    newPhone: {
      name: { required },
      number: { required }
    }
  },

  created () {
    this.listPhoneNumbers()
  },
  methods: {
    addNewPhone () {
      this.newPhone = {
        active: true,
        name: '',
        number: ''
      }
    },

    createPhoneNumber (phoneNumber) {
      this.$v.newPhone.$touch()
      if (this.$v.newPhone.$invalid) return
      this.$http.post('/api/phone_numbers', this.formData(phoneNumber)).then(() => {
        this.appendSuccess({ message: 'Created phoneNumber successfully', notification: true})
        this.redirectToPhoneNumberList()
      }, (responseError) => {
        this.appendError({error: responseError.body.error, notification: true})
      })
    },

    editPhoneNumber (phoneNumber) {
      phoneNumber.editable = !phoneNumber.editable
      this.selectedPhoneNumber = this.deepCloneObject(phoneNumber)
    },

    formData (phone) {
      return {
        phoneNumber: {
          name: phone.name,
          number: phone.number
        }
      }
    },

    listPhoneNumbers () {
      this.$http.get('/api/phone_numbers', { params: this.tableParams }).then((result) => {
        this.phoneNumbers = result.data.phoneNumbers
        this.meta = result.data.meta
      }, (responseError) => {
        this.appendError({error: responseError.body.error, notification: true})
      })
    },

    removePhoneNumber () {
      alert('Did it')
    },

    resetNewPhone () {
      this.newPhone = {
        active: false,
        name: '',
        number: ''
      }
    },

    updatePhoneNumber (phoneNumber) {
      this.$v.selectedPhoneNumber.$touch()
      if (this.$v.selectedPhoneNumber.$invalid) return
      this.$http.put(`/api/phone_numbers/${this.selectedPhoneNumber.id}`, this.formData(phoneNumber)).then(() => {
        this.appendSuccess({ message: 'Updated phoneNumber successfully', notification: true})
        phoneNumber.editable = false
      }).catch(error => {
        this.appendError({ error: error , notification: true})
      })
    }
  }
}
</script>

<style scoped lang="scss">
</style>
