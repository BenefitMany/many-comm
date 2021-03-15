<template>
  <div
    class="cursor-pointer detail-code py-1">
    <span :class="'badge-'+code.displayStatus" class="badge badge-pill mr-2">
      {{ code.statusCode }}
    </span>
    <span
      :title="code.description"
      data-toggle="tooltip"
      data-placement="bottom">
      {{ code.statusTitle }}
    </span>
  </div>
</template>

<script>
export default {
  props: {
    code: {
      default: () => [],
      type: Object
    }
  }
}
</script>

<style lang="css">
.detail-code {
  display: flex;
  align-items: center;
}
</style>
