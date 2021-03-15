<template>
  <div v-html="compiledMarkdown"/>
</template>

<script>
import marked from 'marked'

export default {
  props: {
    source: { default: '', type: String }
  },
  computed: {
    compiledMarkdown: function () {
      if (this.source) {
        return marked(this.source, { sanitize: true, breaks: true })
      }
      return ''
    }
  }
}
</script>

<style scoped>
</style>
