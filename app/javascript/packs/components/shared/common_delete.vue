<template>
  <div :id="'delete-modal-' + deleteObject.indx" class="fade modal" tabindex="-1" role="dialog" aria-labelledby="delete" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 id="delete-modal-label" class="modal-title">
            Delete {{ deleteObject.name }}?
          </h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          Are you sure you want to delete {{ deleteObject.name }}?
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-dismiss="modal">
            Close
          </button>
          <button type="button" class="btn btn-danger" data-dismiss="modal" @click="confirmDelete(deleteObject.entry)">
            Delete
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    deleteObject: {
      type: Object,
      default () {
        return {
          indx: 0,
          tableName: 'Type of Delete', // User, Procedure, Order
          name: 'Specific Type',
          entry: {}
        }
      }
    },
    confirmDeleteCallback: {
      default: function () {
        console.log('confirmDeleteCallback is not defined')
      },
      type: Function
    }
  },
  methods: {
    confirmDelete (entry) {
      try {
        this.confirmDeleteCallback(entry)
      } catch (e) {
        console.log('confirmDelete was called but confirmDeleteCallback was not set')
      }
    }
  }
}
</script>

<style>

</style>
