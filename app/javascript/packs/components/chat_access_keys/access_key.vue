<template>
  <div class="card">
    <div class="card-header capitalize">
      <span class="float-right cursor-hand" @click.prevent="removeAccessKey()">
        Delete
        <i class="fa fa-trash"/>
      </span>
    </div>
    <div class="card-body">
      <div>
        <span class="text-muted">Access Key:</span>
        {{ accessKey.accessKey }}
      </div>
      <div>
        <span class="text-muted">Times Accessed:</span>
        {{ accessKey.accessed }}
      </div>
      <div>
        <span class="text-muted">Created At:</span>
        {{ accessKey.createdAt }}
      </div>
    </div>
  </div>
</template>

<script>

export default {
  props: {
    accessKeyProp: {
      type: Object,
      default () {
        return {}
      }
    }
  },

  data () {
    return {
      accessKey: {}
    }
  },

  created () {
    this.accessKey = this.deepCloneObject(this.accessKeyProp)
  },

  methods: {

    removeAccessKey () {
      this.$http.delete(`/api/chat_access_keys/${this.accessKey.id}`).then(() => {
        this.appendSuccess({ message: 'Removed access key successfully', notification: true })
        this.$emit('listAccessKeys')
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
