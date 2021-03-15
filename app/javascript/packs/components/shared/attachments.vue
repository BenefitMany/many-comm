<template>
  <div>
    <div id="itemAttachmentModal" tabindex="-1" role="dialog" class="modal fade text-left">
      <div role="document" class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">
              Attached Files
            </h5>
            <button
              type="button"
              data-dismiss="modal"
              class="close"
              @click.prevent="cancelAttachedFilesForm">
              <span>×</span>
            </button>
          </div>
          <div class="modal-body">
            <form>
              <div class="row">
                <div class="col-sm-12 text-right">
                  <button type="button" class="btn btn-primary" @click="addAttachment">
                    Add Attachment
                  </button>
                </div>
              </div>
              <div class="row">
                <div class="col-sm-1"/>
                <div class="col-sm-11">
                  File
                </div>
              </div>
              <div v-for="(attachment, attachmentIndex) in attachmentList" :key="attachmentIndex" class="row file-attachment">
                <div v-show="showItemAttachment(attachment)" class="col-sm-1 text-right">
                  <i class="fa fa-trash" @click="removeAttachment(attachmentIndex)"/>
                </div>
                <div v-show="showItemAttachment(attachment)" class="col-sm-11">
                  <div v-if="!attachment.fileName">
                    <input
                      :data-attachment-index="attachmentIndex"
                      type="file"
                      class="file-input"
                      style="display: none"
                      @change="onFileSelected">
                    <button @click.prevent="openPickFileWindow">
                      Pick File
                    </button>
                  </div>
                  <div v-else>
                    {{ attachment.fileName }}
                  </div>
                </div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <div class="col-sm-12 text-right">
              <button type="button" data-dismiss="modal" class="btn btn-secondary" @click.prevent="cancelAttachedFilesForm">
                Cancel
              </button>
              <button type="button" class="btn btn-primary" @click.prevent="updateAttachedFilesForm">
                Done
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
export default {

  props: {
    attachments: {
      default: () => [],
      type: Array
    }
  },
  data () {
    return {
      attachmentList: []
    }
  },
  watch: {
    attachments (newItemAttachments) {
      this.attachmentList = this.deepCloneObject(newItemAttachments)
    }
  },
  methods: {
    showItemAttachment (attachment) {
      return this.toDestroy(attachment._destroy) != 1
    },

    addAttachment () {
      this.attachmentList.push({ fileAttachmentId: null, fileName: '', url: '' })
    },

    removeAttachment (attachmentIndex) {
      this.attachmentList[attachmentIndex]._destroy = 1
      event.target.closest('.file-attachment').style.display = 'none'
    },

    openPickFileWindow (event) {
      $(event.target.parentNode).find('.file-input')[0].click()
      // $(event.target).closest('.file-input').click()
    },

    onFileSelected (event) {
      this.onUpload(event.target.files[0], event.target.dataset.attachmentIndex)
    },

    onUpload (selectedFile, selectedIndex) {
      const fd = new FormData()
      fd.append('fileAttachment[file]', selectedFile, selectedFile.name)

      const fdStatus = {
        onUploadProgress: uploadEvent => {
          console.log('Upload Progress: ' + Math.round(uploadEvent.loaded / uploadEvent.total * 100) + '%')
        }
      }

      axios.post('/api/file_attachments', fd, fdStatus).then((result) => {
        this.attachmentList[selectedIndex].fileAttachmentId = result.data.fileAttachment.id
        this.attachmentList[selectedIndex].fileName = result.data.fileAttachment.fileName
        this.attachmentList[selectedIndex].url = result.data.fileAttachment.url
      }).catch(error => {
        this.appendError({ error: error.response.data.error })
      })
    },

    cancelAttachedFilesForm () {
      this.attachmentList = this.deepCloneObject(this.attachments)
      $('.file-attachment').each((fileEntryIndex, fileEntry) => { $(fileEntry).show() })
      $('#itemAttachmentModal').modal('hide')
    },

    updateAttachedFilesForm () {
      this.$emit('updateAttachments', this.attachmentList)
      this.cancelAttachedFilesForm()
    }
  }
}
</script>

<style scoped>
</style>
