<template>
  <div>
    <app-common-messages :messages="appMessages" @resetMessages="resetAppMessages"/>
    <app-common-table
      :table-name="'Users'"
      :columns="tableColumns"
      :data="users"
      :meta="meta"
      :state-change-callback="updateTable"
      :new-entry-callback="newUser"
      :edit-entry-callback="editUser"
      :remove-entry-callback="removeUser"
      :remove-entry-message-callback="displayRemovalUserName"/>
  </div>
</template>

<script>
import CommonTable from '@shared/common_table/common_table.vue'
import CommonMessages from '@shared/common_messages.vue'

export default {
  components: {
    appCommonTable: CommonTable,
    appCommonMessages: CommonMessages
  },
  data () {
    return {
      tableColumns: [
        { display: 'name', column: 'name', columnFn: this.displayName },
        { display: 'admin', column: 'admin', formatters: ['booleanYesNo'] },
        'email', 'lastLoginAt',
        { rowOptions: true }
      ],
      users: [],
      meta: {page: 1, perPage: 25, search: '', sort: null, order: null},
      tableParams: { page: 1, perPage: 25, search: '', sort: null, order: null }
    }
  },

  created () {
    this.updateTable()
  },
  methods: {
    displayName (user) {
      if(this.isBlank(user)) { return '' }
      return [user.firstName, user.lastName].join(' ')
    },

    editUser (user) {
      this.$router.push({ name: 'userEdit', params: { id: user.id }})
    },

    displayRemovalUserName (user) {
      try {
        const name = [user.firstName, user.lastName].join(' ')
        return `the user for ${name}`
      } catch (error) {
        return 'the user'
      }
    },

    formData () {
      return {
        user: {
          firstName: this.user.firstName,
          lastName: this.user.lastName,
          email: this.user.email,
          password: this.user.password,
          passwordConfirmation: this.user.passwordConfirmation
        }
      }
    },

    listUsers () {
      this.$http.get('/api/users', { params: this.tableParams }).then((result) => {
        this.users = result.data.users
        this.meta = result.data.meta
      }).catch(error => {
        this.appendError({ error: error.response.data.error })
      })
    },

    newUser () {
      this.$router.push({ name: 'userNew' })
    },

    removeUser (user) {
      this.$http.delete(`/api/users/${user.id}`).then(() => {
        this.appendSuccess({ message: 'Removed user successfully'})
        this.updateTable()
      }).catch(error => {
        this.appendError({ error: error.response.data.error })
      })
    },

    updateTable () {
      this.tableParams = {
        page: this.meta.page,
        perPage: this.meta.perPage,
        search: this.meta.search,
        sort: this.meta.sort,
        order: this.meta.order
      }
      this.listUsers()
    }
  }
}
</script>

<style>
</style>
