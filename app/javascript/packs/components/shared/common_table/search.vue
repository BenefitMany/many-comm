<template>
  <input
    :placeholder="searchPlaceholder"
    :value="searchValue"
    type="text"
    class="form-control"
    aria-label="Search for..."
    @input="updateSearch">
</template>

<script>
import debounce from 'lodash/debounce'

export default {
  props: {
    searchValue: {default: '', type: String},
    searchPlaceholder: { default: 'Search for ...', type: String }
  },
  methods: {
    updateSearch: debounce(function (e) {
      this.$emit('updateSearch', e.target.value)
    }, 500)
  }
}
</script>
