<template>
  <div class="common-table-wrapper">
    <header v-if="!inLineTableHeader" class="align-items-center d-flex pt-3 row">
      <div class="col">
        <h3 v-if="tableName" :class="{'card-title p-2 pl-3': !showCardClass}" class="display service-form-list-table-name">
          {{ tableName }}
        </h3>
        <span v-if="tableSubtitle.display" :class="{'card-title p-2 pl-3': !showCardClass}" class="card-subtitle service-form-list-table-name text-muted">{{ tableSubtitle.text }}</span>
      </div>
      <slot v-if="hasHeaderSlot()" name="header"/>
      <div v-if="showNewButton && showNewCondition()" class="col-md-12 my-2">
        <button class="btn btn-primary float-right mr-4" @click.prevent="newEntry">
          {{ newText }}
        </button>
      </div>
      <div v-if="showNewIconButton.display" class="col mr-3">
        <button type="button" class="btn btn-circle btn-default float-right" @click.prevent="newEntry">
          <i :class="showNewIconButton.icon"/>
        </button>
      </div>
    </header>

    <div class="no-gutters row">
      <div class="col-sm-12">
        <div :class="{'card': showCardClass}">
          <div v-if="showCardHeader" class="card-header px-1">
            <div class="m-0 row w-100">
              <div v-if="showNewButton && showNewCondition() && inLineTableHeader" class="col-md-12 my-2">
                <button class="btn btn-primary float-right" @click.prevent="newEntry">
                  {{ newText }}
                </button>
              </div>
              <div v-if="showPagination" class="col-sm-3 text-nowrap">
                <label class="mr-sm-2" for="inlineFormCustomSelect">View:</label>
                <select v-model="meta.perPage" class="custom-select mb-2 mb-sm-0 mr-sm-2 w-50" @change="updateTable">
                  <option disabled>
                    Choose...
                  </option>
                  <option v-for="(option, optionIndx) in perPageOptions" :key="optionIndx">
                    {{ option }}
                  </option>
                </select>
              </div>
              <div class="col-sm-6 text-left text-nowrap">
                <slot/>
              </div>
              <div v-if="showSearchFilter" class="col-sm-3 input-group">
                <common-table-search :search-value="meta.search" :search-placeholder="searchPlaceholder" @updateSearch="updateSearch"/>
              </div>
            </div>
          </div>
          <div class="card-block table-responsive">
            <table class="table table-hover" :class="[ textSmall ? 'table-text-small' : '' ]">
              <thead>
                <tr>
                  <th
                    v-for="(columnHeader, columnHeaderIndex) in columns"
                    :key="columnHeaderIndex"
                    :class="[columnHeader.class, {'cursor-hand': headerSortable(columnHeader)}]"
                    @click="(headerSortable(columnHeader) ? sortBy(columnHeader) : null)">
                    {{ headerName(columnHeader) | titleize }}
                    <span v-show="headerSortable(columnHeader)" class="font_size_half">
                      <span :class="{ 'active': activeSort(columnHeader, 'ASC')}" class="arrow asc"/>
                      <br class="small_br">
                      <span :class="{ 'active': activeSort(columnHeader, 'DESC') }" class="arrow dsc"/>
                    </span>
                  </th>
                </tr>
              </thead>
              <!-- TODO: Figure out how to disable hover styles on tooltip, explore other loading options -->
              <tbody :class="{ 'loading': loadingTableAfterDuration }">
                <tr v-if="loadingTableAfterDuration">
                  <td class="px-auto py-5 text-center" colspan="100">
                    <i class="fa fa-3x fa-cog fa-spin px-auto" style="color: #6C7C9C;"/>
                  </td>
                </tr>
                <tr
                  v-for="(entry, rowIndex) in data"
                  v-show="entry._destroy != 1"
                  :key="rowIndex"
                  :class="[rowClass(entry)]">
                  <td v-for="(column, colIndex) in columns" :key="'row'+rowIndex +'col'+ colIndex +'tableLen'+ data.length" :class="column.class">
                    <template v-if="showRowOptions(column)">
                      <div v-if="optionEllipsis" class="dropdown dropleft">
                        <span :id="'dropdownMenu2'+ tableNameId + rowIndex + colIndex" class="cursor-hand px-2" data-toggle="dropdown">
                          <i class="fa fa-ellipsis-v mx-auto" aria-haspopup="true" aria-expanded="false"/>
                        </span>
                        <div :aria-labelledby="'dropdownMenu2'+ tableNameId + rowIndex + colIndex" class="dropdown-menu">
                          <h6 class="dropdown-header font-weight-bold text-capitalize">
                            {{ removeEntryMessage(entry, columns) }}
                          </h6>
                          <div class="dropdown-divider"/>
                          <span
                            v-for="(linkInfo, linkInfoIndex) in additionalLinkOptions"
                            v-show="entryActionShowCondition(linkInfo.conditionFn, entry)"
                            :key="linkInfoIndex"
                            class="cursor-hand dropdown-item"
                            @click="entryAction(linkInfo.actionFn, entry)">
                            <i :key="linkInfoIndex" :class="linkInfo.cssClasses" class=""/>
                            {{ linkInfo.title }}
                          </span>
                          <span
                            v-if="entry._destroy != 1 && showEditOption == true && showEditCondition(entry)"
                            class="cursor-hand dropdown-item"
                            @click="editEntry(entry)">
                            <i class="fa fa-fw fa-pencil"/>
                            Edit
                          </span>
                          <span
                            v-if="showDeleteOption && showDeleteCondition(entry)"
                            :data-target="'#delete-modal-' + [tableNameId, colIndex, rowIndex].join('-')"
                            class="cursor-hand dropdown-item"
                            data-toggle="modal"
                            @click="entry.showModal = true">
                            <i class="fa fa-fw fa-trash"/>
                            Delete
                          </span>
                        </div>
                      </div>
                      <div v-else>
                        <span
                          v-for="(linkInfo, linkInfoIndex) in additionalLinkOptions"
                          v-show="entryActionShowCondition(linkInfo.conditionFn, entry)"
                          :key="linkInfoIndex"
                          :title="linkInfo.title"
                          data-toggle="tooltip"
                          class="tooltip-area">

                          <i
                            :key="linkInfoIndex"
                            :class="linkInfo.cssClasses"
                            :data-toggle="linkInfo.dataToggle"
                            :data-target="linkInfo.dataTarget"
                            aria-hidden="true"
                            @click="entryAction(linkInfo.actionFn, entry)"/>
                        </span>
                        <span
                          v-if="entry._destroy != 1 && showEditOption == true"
                          data-toggle="tooltip"
                          title="Edit"
                          class="tooltip-area">
                          <i
                            class="fa fa-pencil"
                            aria-hidden="true"
                            @click="editEntry(entry)"/>
                        </span>
                        <span
                          v-if="showDeleteOption"
                          v-show="entryActionShowCondition(showDeleteCondition, entry)"
                          data-toggle="tooltip"
                          title="Delete"
                          class="tooltip-area">
                          <i
                            :data-target="'#delete-modal-' + [_uid, rowIndex].join('-')"
                            class="fa fa-trash"
                            aria-hidden="true"
                            data-toggle="modal"/>
                        </span>
                      </div>
                      <app-common-delete
                        :delete-object="{tableName: tableName, name: removeEntryMessage(entry, columns), indx: [tableNameId, colIndex, rowIndex].join('-'), entry: entry}"
                        :confirm-delete-callback="removeEntry"/>
                      <app-common-delete
                        :delete-object="{tableName: tableName, name: removeEntryMessage(entry, columns), indx: [_uid, rowIndex].join('-'), entry: entry}"
                        :confirm-delete-callback="removeEntry"/>
                    </template>
                    <template v-else-if="renderColumnFunction(column)">
                      <div v-if="column['render'] == 'badge'">
                        <app-common-table-badge
                          :code="column['columnFn'](entry)"/>
                      </div>
                      <div v-else-if="!isBlank(column['cellFn'])" @click="column['cellFn'](entry)" v-html="column['columnFn'](entry)"/>
                      <div v-else v-html="column['columnFn'](entry)"/>
                    </template>
                    <vue-markdown v-else-if="column.markdown" :source="entry[headerColumn(column)]"/>
                    <template v-else>
                      <div v-html="applyFormatters(entry[headerColumn(column)], headerFormatters(column))"/>
                    </template>
                  </td>
                </tr>
              </tbody>
            </table>
            <common-table-pagination
              v-if="showPagination"
              :meta="meta"
              :state-change-callback="updateTable"/>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import includes from 'lodash/includes'
import VueMarkdown from '../vue_markdown.vue'
import CommonDelete from '../common_delete.vue'
import CommonTablePagination from './pagination.vue'
import CommonTableSearch from './search.vue'
import CommonTableBadge from './badge.vue'

export default {
  components: {
    'vue-markdown': VueMarkdown,
    'app-common-delete': CommonDelete,
    'common-table-pagination': CommonTablePagination,
    'common-table-search': CommonTableSearch,
    'app-common-table-badge': CommonTableBadge
  },
  filters: {
    titleize (str) {
      // If the string is camelcase then add a space in front of each capital letter and then capitalize the first character.
      if ((str === '' || str == undefined || str == null)) { return '' }
      if (str.charAt(0).toUpperCase() == str.charAt(0)) {
        return str
      }
      return str.charAt(0).toUpperCase() + str.replace(/([A-Z])/g, ' $1').slice(1)
    }
  },
  props: {
    loadingBooleanProp: {default: false, type: Boolean},
    showCardHeader: { default: true, type: Boolean },
    inLineTableHeader: { default: true, type: Boolean },
    showCardClass: { default: true, type: Boolean},
    newText: { default: 'New', type: String },
    showPagination: { default: true, type: Boolean },
    showSearchFilter: { default: true, type: Boolean },
    searchPlaceholder: { default: 'Search for ...', type: String },
    showNewButton: { default: true, type: Boolean },
    showEditOption: { default: true, type: Boolean },
    showDeleteOption: { default: true, type: Boolean },
    optionEllipsis: { default: true, type: Boolean },
    textSmall: { default: false, type: Boolean },
    filterKey: {
      default: '',
      type: String
    },
    columns: {
      default: () => [],
      type: Array
    },
    data: {
      default: () => [],
      type: Array
    },
    tableName: { type: String, default: '' },
    additionalLinkOptions: { default () { return [] }, type: Array },
    tableSubtitle: {
      type: Object,
      default () {
        return {
          display: false,
          text: ''
        }
      }
    },
    showNewIconButton: {
      type: Object,
      default () {
        return {
          icon: '',
          display: false
        }
      }
    },

    stateChangeCallback: {
      type: Function,
      default: function () { return '' },
      required: false
    },
    newEntryCallback: {
      type: Function,
      default: function () { return '' },
      required: false
    },
    editEntryCallback: {
      type: Function,
      default: function () { return '' },
      required: false
    },
    showNewConditionCallback: {
      type: Function,
      required: false,
      default () { return true }
    },
    showEditConditionCallback: {
      type: Function,
      default: function () { return true },
      required: false
    },
    showDeleteConditionCallback: {
      type: Function,
      default: function () { return true },
      required: false
    },
    removeEntryMessageCallback: {
      type: Function,
      default: function () { return '' },
      required: false
    },
    removeEntryCallback: {
      type: Function,
      default: function () { return '' },
      required: false
    },
    rowClassCallback: {
      default: function () { return '' },
      type: Function,
      required: false
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
  data () {
    const sortOrders = {}
    this.columns.forEach((column) => {
      sortOrders[ this.headerColumn(column) ] = 1
    })
    return {
      loadingTableAfterDuration: false,
      loadingTimeout: '',
      sortKey: '',
      sortOrders: sortOrders,
      perPageOptions: [5, 10, 25, 50]
    }
  },
  computed: {
    tableNameId () {
      return this.tableName.replace(/ /g, '_').toLowerCase()
    }
  },
  watch: {
    loadingBooleanProp: {
      immediate: true,
      handler (newPropValue) {
        const self = this
        if (newPropValue) {
          this.loadingTimeout = setTimeout(function () {
            self.loadingTableAfterDuration = true
          }, 300)
        } else {
          clearTimeout(this.loadingTimeout)
          self.loadingTableAfterDuration = false
        }
      }
    }
  },
  updated () {
    $('[data-toggle="tooltip"]').tooltip().click(function () { $(this).tooltip('hide') })
  },
  methods: {
    hasHeaderSlot () {
      return !!this.$slots.header
    },
    showDeleteCondition (entry) {
      try {
        return this.showDeleteConditionCallback(entry)
      } catch (e) {
        return true
      }
    },

    showEditCondition (entry) {
      try {
        return this.showEditConditionCallback(entry)
      } catch (e) {
        return true
      }
    },

    showNewCondition () {
      try {
        return this.showNewConditionCallback()
      } catch (e) {
        return true
      }
    },

    updateSearch (searchVal) {
      this.meta.search = searchVal
      this.updateTable()
    },

    updateTable () {
      try {
        this.stateChangeCallback()
      } catch (e) {
        console.log('updateTable was called but stateChangeCallback was not set')
      }
    },
    activeSort (columnHeader, orderString) {
      const name = this.headerColumn(columnHeader)
      return (
        this.meta.sort &&
            this.meta.sort.length &&
            includes(this.meta.sort.toLowerCase(), name.toLowerCase()) &&
            this.meta.order == orderString
      )
    },
    sortBy (columnHeader) {
      const name = this.headerColumn(columnHeader)
      this.sortKey = name
      this.sortOrders[name] = this.sortOrders[name] * -1
      this.meta.sort = name
      this.meta.order = this.sortOrders[name] > 0 ? 'ASC' : 'DESC'
      this.updateTable()
    },
    newEntry () {
      try {
        this.newEntryCallback()
      } catch (e) {
        console.log('newEntry was called but newEntryCallback was not set')
      }
    },
    editEntry (entry) {
      try {
        this.editEntryCallback(entry)
      } catch (e) {
        console.log('editEntry was called but editEntryCallback was not set')
      }
    },
    removeEntryMessage (entry, columns) {
      if (this.isBlank(this.removeEntryMessageCallback())) {
        if (typeof columns[0] == 'string') {
          if (columns[0] == 'id') {
            return `${this.tableName} ${entry[columns[0]]}`
          }
          return entry[columns[0]]

        }
        return 'this row'

      }
      try {
        return this.removeEntryMessageCallback(entry)
      } catch (e) {
        return 'this row'
      }
    },
    removeEntry (entry) {
      try {
        this.removeEntryCallback(entry)
      } catch (e) {
        console.log('removeEntry was called but removeEntryCallback was not set')
      }
    },
    entryAction (actionFn, entry) {
      return actionFn(entry)
    },
    entryActionShowCondition (conditionFn, entry) {
      if (this.isUndefined(conditionFn)) { return true }
      return conditionFn(entry)
    },
    rowClass (entry) {
      try {
        return this.rowClassCallback(entry)
      } catch (e) {
        return ''
      }
    },
    headerName (column) {
      if (typeof column == 'string' || column instanceof String) { return column }
      if (column.displayFn != undefined) { return column.displayFn(column) }
      if (this.isUndefined(column.display)) { return column.column }
      return column.display
    },
    headerColumn (column) {
      if (typeof column == 'string' || column instanceof String) { return column }
      if (column.rowOptions) { return '' }
      return column.column || ''
    },
    renderColumnFunction (column) {
      return column.columnFn instanceof Function
    },
    headerSortable (column) {
      if (this.isUndefined(this.stateChangeCallback)) { return false }
      if (typeof column == 'string' || column instanceof String) { return true }
      if (column.rowOptions) { return false }
      if (this.isUndefined(column.sortable)) { return true }
      return column.sortable
    },
    headerFormatters (column) {
      if (typeof column == 'string' || column instanceof String) { return [] }
      if (this.isUndefined(column.formatters)) { return [] }
      if (column.formatters instanceof Array) { return column.formatters }
      if (column.formatters instanceof String) { return [column.formatters] }
      return [] // Assume invalid
    },
    applyFormatters (data, formatters) {
      if (this.isUndefined(formatters)) { return data }
      formatters.forEach((formatter) => {
        if (formatter == 'currency') { data = this.$options.filters.currency(data) }
        if (formatter == 'decimalToPercent') { data = this.$options.filters.decimalToPercent(data) }
        if (formatter == 'intToPercent') { data = this.$options.filters.intToPercent(data) }
        if (formatter == 'booleanYesNo') { data = this.$options.filters.booleanYesNo(data) }
      })
      return data
    },
    showRowOptions (column) {
      if (typeof column == 'string' || column instanceof String) { return false }
      if (this.isUndefined(column.rowOptions)) { return false }
      return column.rowOptions
    },
    showTranscendCard () {
      return this.$route.meta.removeGSN ? true : false
    }
  }
}
</script>

<style scoped lang="scss">

.loading, .loading> tr:hover {
  width: 100%;
  height: 100%;
  position: relative;
  color: rgba(229, 229, 229, 0.7) !important;
  background-color: rgba(229, 229, 229, 0.7);
}

.cursor-hand {
  cursor: pointer;
}

.table thead th {
  white-space: nowrap;
  font-weight: 600;
}

.service-form-list-table-name {
  text-transform: capitalize;
}

span.tooltip-area {
  font-size: 1em;
  color: #666666;
}

.loading {
  span.tooltip-area {
    font-size: 1em;
    color: rgba(229, 229, 229, 0.7) !important;
  }
}

table td {
  vertical-align: middle;
}

.table-text-small {
  font-size: .9rem;
}

td i {
  cursor: pointer;
  margin-right: 4px;
}

.cursor-pointer {
  cursor: pointer;
}

.font_size_half {
  display: inline-block;
  font-size: 0.2em;
}

.dropdown, .dropleft, .dropright, .dropup {
  position: inherit;
}

.small_br {
  line-height: 35%
}

.arrow {
  display: inline-block;
  vertical-align: middle;
  width: 0;
  height: 0;
  margin-left: 5px;
  opacity: 0.66;
}

.arrow.asc {
  border-left: 4px solid transparent;
  border-right: 4px solid transparent;
  border-bottom: 4px solid #9F9F9F;
}
.arrow.asc.active {
  border-bottom: 4px solid #000;
}

.arrow.dsc {
  border-left: 4px solid transparent;
  border-right: 4px solid transparent;
  border-top: 4px solid #9F9F9F;
}

.arrow.dsc.active {
  border-top: 4px solid #000;
}

.btn-circle {
  background-color: #007bff;
  color: #ffffff;
  width: 2em;
  height: 2em;
  padding: 6px 0px;
  border-radius: 50%;
  text-align: center;
  font-size: 1.5em;
  line-height: 1.42857;
}
</style>
