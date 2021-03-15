<template>
  <div
    v-if="hasMessages()"
    :class="{'alert-danger': hasErrors(), 'alert-success': hasSuccesses() }"
    class="alert mt-2 text-left"
    role="alert">
    <button type="button" class="close" aria-label="Close" @click="removeError">
      <span aria-hidden="true">&times;</span>
    </button>
    <ul class="list-unstyled">
      <li v-for="(msg, msgIndex) in displayMessages" :key="msgIndex">
        {{ msg }}
      </li>
    </ul>
  </div>
</template>

<script>

export default {
  props: {
    messages: {
      type: Object,
      default: () => ({successes: [], errors: []}),
      required: true
    }
  },
  computed: {
    displayMessages () {
      if (this.hasErrors()) { return this.messages.errors }
      if (this.hasSuccesses()) { return this.messages.successes }
      return []
    }
  },
  methods: {
    hasMessages () {
      return (this.hasErrors() || this.hasSuccesses())
    },
    hasErrors () {
      if (this.isBlank(this.messages.errors) || this.isZero(this.messages.errors.length)) {
        return false
      }
      return true
    },
    hasSuccesses () {
      if (this.isBlank(this.messages.successes) || this.isZero(this.messages.successes.length)) {
        return false
      }
      return true
    },
    removeError () {
      this.$emit('resetMessages')
    }
  }
}
</script>

<style scoped>
</style>
