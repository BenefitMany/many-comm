<template>
  <div>
    <div class="bm-alert-float">
      <transition-group name="fade" mode="in-out" class="w-100">
        <div v-for="(error, errorIndx) in errorMessages" :key="'errorKey'+errorIndx" role="alert" class="alert alert-danger mt-2 text-left">
          <button type="button" class="close" aria-label="Close" @click="removeError(errorIndx)">
            <span aria-hidden="true">&times;</span>
          </button>
          <p>{{ error }}</p>
        </div>
      </transition-group>

      <transition-group name="fade" mode="in-out" class="w-100">
        <div v-for="(success, successIndx) in successMessages" :key="'successKey'+successIndx" role="alert" class="alert alert-success mt-2 text-left">
          <button type="button" class="close" aria-label="Close" @click="removeSuccess(successIndx)">
            <span aria-hidden="true">&times;</span>
          </button>
          <p>{{ success }}</p>
        </div>
      </transition-group>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'

export default {
  computed: {
    errorMessages () {
      return this.notificationErrors()
    },
    successMessages () {
      return this.notificationSuccesses()
    }

  },
  methods: {
    ...mapActions(['spliceNotificationError', 'spliceNotificationSuccess']),
    ...mapGetters(['notificationErrors', 'notificationSuccesses']),
    removeError (errorIndx) {
      this.spliceNotificationError(errorIndx)
    },
    removeSuccess (successIndx) {
      this.spliceNotificationSuccess(successIndx)
    }
  }
}
</script>

<style scoped lang="scss">
.bm-alert-float {
  top: 0;
  position: fixed;
  left: 10px;
  z-index: 99999;
  width: 40%;
}
</style>
