<template>
  <div class="card">
    <div class="card-header capitalize">
      Type: {{ responder.responseType | titleize }}
      <span v-show="!editing" class="float-right cursor-hand" @click="editResponder()">
        Edit
        <i class="fa fa-pencil"/>
      </span>
    </div>
    <div v-show="!editing" class="card-body">
      <div>
        <span class="text-muted">Message:</span>
        {{ responder.message }}
      </div>
      <div>
        <span class="text-muted">Status:</span>
        {{ responder.active ? 'Active' : 'Inactive' }}
      </div>
      <div>
        {{ responder.statusChangedAt | dateMMDDYYHHMM }}
      </div>
    </div>
    <div v-show="editing" class="card-body row no-gutters">
      <div class="form-group col-md-12">
        <label for="responderMessage">Responder Message</label>
        <input
          id="responderMessage"
          v-model="responder.message"
          :class="{ 'highlighter-red': $v.responder.message.$error }"
          type="text"
          class="form-control"
          @blur="$v.responder.message.$touch()">
      </div>
      <div class="col-md-12 my-auto">
        <span>{{ responder.active ? 'Active': 'Inactive' }}</span>
        <br>
        <label class="switch">
          <input v-model="responder.active" type="checkbox">
          <span class="slider round"/>
        </label>
      </div>
      <div class="col-sm-12 text-right">
        <button type="submit" class="btn btn-secondary" @click.prevent="editResponder()">
          Cancel
        </button>
        <button type="submit" class="btn btn-primary" @click.prevent="updateAutoresponder()">
          Save
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import { required } from 'vuelidate/lib/validators'

export default {

  validations: {
    responder: {
      message: { required }
    }
  },

  props: {
    autoresponder: {
      type: Object,
      default () {
        return {
          responseType: 'NOT SET'
        }
      }
    }
  },

  data () {
    return {
      responder: {},
      editing: false
    }
  },

  created () {
    this.responder = this.deepCloneObject(this.autoresponder)
  },

  methods: {
    editResponder () {
      this.editing = !this.editing
    },

    updateAutoresponder () {
      this.$http.put(`/api/autoresponders/${this.responder.id}`, { autoresponder: this.responder }).then(() => {
        this.appendSuccess({ message: 'Updated responder successfully' })
        this.editing = false
      }).catch(error => {
        this.appendError({ error: error.response.data.error, notification: true })
      })
    }
  }
}
</script>

<style lang="scss">
/* The switch - the box around the slider */
.switch {
  position: relative;
  display: inline-block;
  width: 60px;
  height: 34px;
}

/* Hide default HTML checkbox */
.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

/* The slider */
.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  -webkit-transition: .4s;
  transition: .4s;
}

.slider:before {
  position: absolute;
  content: "";
  height: 26px;
  width: 26px;
  left: 4px;
  bottom: 4px;
  background-color: white;
  -webkit-transition: .4s;
  transition: .4s;
}

input:checked + .slider {
  background-color: #2196F3;
}

input:focus + .slider {
  box-shadow: 0 0 1px #2196F3;
}

input:checked + .slider:before {
  -webkit-transform: translateX(26px);
  -ms-transform: translateX(26px);
  transform: translateX(26px);
}

/* Rounded sliders */
.slider.round {
  border-radius: 34px;
}

.slider.round:before {
  border-radius: 50%;
}
</style>
