<template>
  <li>
    <a :href="'#data-enrichment-'+idKey+'-nav-list'" data-toggle="collapse">
      <i :class="'fa '+icon"/><span>{{ name }}</span>
      <div class="arrow pull-right"><i class="fa fa-angle-down"/></div>
    </a>
    <ul :id="'data-enrichment-'+idKey+'-nav-list'" class="collapse list-unstyled">
      <router-link
        v-for="(info, infoIndex) in links"
        :key="infoIndex"
        :to="info.path"
        tag="li">
        <a>{{ info.name }}</a>
      </router-link>
    </ul>
  </li>
</template>

<script>
export default {
  props: {
    icon: {
      default: '',
      type: String
    },
    idKey: {
      default: '',
      type: String
    },
    name: {
      default: '',
      type: String
    },
    links: {
      default: () => [],
      type: Array
    }
  }
}
</script>

<style scoped>
</style>
