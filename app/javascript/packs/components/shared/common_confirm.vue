<template>
  <div :id="confirmModalId" class="fade modal" tabindex="-1" role="dialog" aria-labelledby="confirm" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 id="confirm-modal-label" class="modal-title">
            {{ confirmBoxText }}
          </h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body" v-html="showConfirmMessage()"/>

        <div class="modal-footer">
          <button type="button" class="btn btn-outline-primary" data-dismiss="modal">
            {{ cancelButtonText }}
          </button>
          <button type="button" class="btn btn-primary" data-dismiss="modal" @click="confirm">
            {{ confirmButtonText }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    confirmModalId: { type: String, default: 'confirm-modal' },
    confirmMessage: { type: [String, Function], required: true },
    confirmCallback: { type: Function, required: true },
    confirmBoxText: { type: String, default: 'CONFIRM' },
    cancelButtonText: { type: String, default: 'Cancel' },
    confirmButtonText: { type: String, default: 'Confirm' }
  },
  methods: {
    confirm () {
      try {
        this.confirmCallback()
      } catch (e) {
        console.log('confirm was called but confirmCallback was not set')
      }
    },
    showConfirmMessage () {
      try {
        if (typeof this.confirmMessage == 'function') { return this.confirmMessage() }
        return this.confirmMessage
      } catch (e) {
        console.log('confirm was called but confirmMessage was not set')
      }
    }
  }
}
</script>

<style>
</style>
