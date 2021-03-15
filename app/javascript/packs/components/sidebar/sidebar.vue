<template>
  <div class="sidebar">
    <app-organization/>
    <app-status/>
    <app-operators/>
    <app-conversations/>
  </div>
</template>

<script>
import Organization from './organization.vue'
import Status from './status.vue'
import Operators from './operators_list.vue'
import Conversations from './conversations_list.vue'

export default {
  components: {
    appOrganization: Organization,
    appStatus: Status,
    appOperators: Operators,
    appConversations: Conversations
  },
  data () {
    return { }
  }
}
</script>

<style>
</style>
