<template>
  <div class="availability dropdown" @click="expandStatus">
    <div class="row-wrapper-c">
      <div class="availability__indicator __indicator" :class="indicatorColor()"/>
      <h2 class="availability__title" style="text-transform: capitalize">
        {{ userData.status }}
      </h2>
      <i class="availability__selector fa fa-chevron-down"/>
    </div>
    <div id="statusDropdown" class="dropdown__content" @mouseleave="expandStatus">
      <div class="dropdown__item" @click="updateStatus">
        {{ statusDropdownText() }}
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  data () {
    return {
      userData: {
        status: 'available'
      }
    }
  },

  methods: {
    ...mapActions('socketx', [
      'setUserStatus'
    ]),

    indicatorColor () {
      return this.userData.status == 'available' ? '--green' : '--red'
    },

    expandStatus () {
      document.getElementById('statusDropdown').classList.toggle('show')
    },

    statusDropdownText () {
      return this.userData.status == 'available' ? 'Set yourself to away' : 'Set yourself to active'
    },

    updateStatus () {
      this.userData.status = this.userData.status == 'available' ? 'away' : 'available'
      this.setUserStatus(this.userData.status)
    }
  }
}
</script>

<style lang="scss">
.row-wrapper-c {
  display: flex;
  flex-direction: row;
  align-items: center;
}

.availability__title {
  margin-right: 12px;
}
</style>
