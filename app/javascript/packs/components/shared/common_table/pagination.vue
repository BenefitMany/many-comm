<template>
  <div>
    <div class="align-items-center card-header d-flex pt-3">
      <div class="col-sm-3">
        <p>
          {{ currentPageStart }}
          <span v-show="totalRecords != 0">
            to
            <span v-if="meta.currentPage == meta.totalPages" class="span_no_styles">{{ totalRecords }}</span>
            <span v-else class="span_no_styles">{{ currentPageEnd }}</span>
          </span>
          of {{ totalRecords }}
        </p>
      </div>
      <div class="col-sm-9">
        <nav aria-label="Page navigation example">
          <ul class="justify-content-end pagination pagination-sm">
            <li :class="{'disabled': (meta.currentPage == 1) }" class="page-item">
              <a class="page-link" href="javascript:void(0)" @click="previousPage">
                <span aria-hidden="true">&laquo;</span>
                <span class="sr-only">Previous</span>
              </a>
            </li>
            <li v-for="pageNum in meta.pageNumbers" :key="pageNum" :class="{'active': (meta.currentPage == pageNum) }" class="page-item">
              <a class="page-link" href="javascript:void(0)" @click="gotoPage(pageNum)">{{ pageNum }}</a>
            </li>
            <li :class="{'disabled': (meta.currentPage == meta.totalPages) }" class="page-item">
              <a class="page-link" href="javascript:void(0)" @click="nextPage">
                <span aria-hidden="true">&raquo;</span>
                <span class="sr-only">Next</span>
              </a>
            </li>
          </ul>
        </nav>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    stateChangeCallback: {
      default: function () {
        console.log('stateChangeCallback is not defined')
      },
      type: Function
    },
    meta: {
      type: Object,
      default () {
        return {
          page: 1,
          currentPage: 1,
          perPage: 25,
          totalCount: 25,
          totalPages: 0,
          search: '',
          sort: '',
          order: 'ASC'
        }
      }
    }
  },
  computed: {
    currentPageStart () {
      if ((!this.meta.perPage || !this.meta.currentPage) || this.meta.totalCount == 0) { return 0 }
      return (this.meta.perPage * (this.meta.currentPage - 1)) + 1
    },
    currentPageEnd () {
      if (!this.meta.perPage || !this.meta.currentPage) { return 0 }
      return this.meta.perPage * this.meta.currentPage
    },
    totalRecords () {
      if (!this.meta.totalCount) { return 0 }
      return this.meta.totalCount
    }
  },
  methods: {
    updateTable () {
      try {
        this.stateChangeCallback()
      } catch (e) {
        console.log('updateTable was called but stateChangeCallback was not set')
      }
    },
    nextPage () {
      this.meta.page = this.meta.currentPage + 1
      this.updateTable()
    },
    previousPage () {
      this.meta.page = this.meta.currentPage - 1
      this.updateTable()
    },
    gotoPage (page) {
      this.meta.page = page
      this.updateTable()
    }
  }
}
</script>

<style scoped>
  .span_no_styles {
    font-size: 1em;
  }
</style>
