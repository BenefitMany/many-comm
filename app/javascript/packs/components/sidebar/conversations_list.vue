<template>
  <div class="conversationsList">
    <h2 class="sectionHeader">
      Conversations
    </h2>
    <div
      v-for="(conversation, cIndx) in openConversations"
      :key="'open'+cIndx"
      class="conversation"
      :class="highlightConversation(conversation)"
      @click.prevent="selectConversation(conversation)">
      <div class="conversation__indicator" :class="indicatorColor(conversation)">
        <i class="conversation__indicatorIcon fa" :class="indicatorIcon(conversation)"/>
      </div>
      <div class="conversation__name" :class="conversationUnread(conversation)">
        {{ conversation.alias }}
      </div>
      <i v-if="conversation.mobile" class="conversation__mobileIcon fa fa-mobile"/>
    </div>
    <hr class="bg-white">
    <div
      v-for="(resolvedConversation, rcIndx) in resolvedConversations"
      :key="'res'+rcIndx"
      class="conversation"
      @click.prevent="selectConversation(resolvedConversation)">
      <div class="conversation__indicator" :class="indicatorColor(resolvedConversation)">
        <i class="conversation__indicatorIcon fa" :class="indicatorIcon(resolvedConversation)"/>
      </div>
      <div class="conversation__name --italic">
        {{ resolvedConversation.alias }}
      </div>
      <i v-if="resolvedConversation.mobile" class="conversation__mobileIcon fa fa-mobile"/>
    </div>
  </div>
  <!-- <div class="row no-gutters border-radius-container">
    <div class="conversation-list col-md-3 border-radius-container">
      <div class="row no-gutters">
        <div class="col-md-12 text-center p-2">
          <h2>Conversations</h2>
        </div>
      </div>
      <div
        v-for="(conversation, cIndx) in conversations"
        :key="cIndx"
        :class="{'conversation-preview-active': conversation.active}"
        class="row no-gutters conversation-preview p-1"
        @click.prevent="selectConversation(conversation)">
        <h3 class="col-md-6">
          {{ conversation.name.split('::')[0] }}
        </h3>
        <div class="col-md-6 text-right">
          {{ conversation.updatedAt | dateMMDDYY }}
        </div>
        <br>
        <span class="text-muted">{{ conversation.lastMessage }}</span>
      </div>
    </div>
    <transition name="extra">
      <app-messages
        :messages="selectedConversationMessages"
        class="col-md-9"
        @createMessage="createMessage"/>
    </transition>
  </div> -->
</template>

<script>
/* eslint-disable no-undef */
// import Messages from './messages.vue'
import { mapGetters, mapActions } from 'vuex'

export default {
  data () {
    return {
      conversations: [],
      selectedConversation: {},
      selectedConversationMessages: [],
      incomingMessage: null
    }
  },

  computed: {
    ...mapGetters('socketx',['getCurrentOperatorStatus']),
    openConversations: function () {
      return this.conversations.filter(function (con) {
        return !con.resolved
      })
    },
    resolvedConversations: function () {
      return this.conversations.filter(function (con) {
        return con.resolved
      })
    }
  },

  watch: {
    getCurrentOperatorStatus (newOperatorStatus) {
      // console.log('Watch Operator Status')
      if(newOperatorStatus == 'away') {
        this.selectedConversation = {}
      }
    }
  },

  created () {
    this.addConversationListListener(this.receiveConversations)
    this.addConversationNewListener(this.receiveNewConversation)
    this.addConversationRemoveListener(this.receiveRemoveConversation)
    this.addMessageNewListener(this.receiveNewMessage)
    this.addConversationResolvedListener(this.receiveResolvedConversation)
    this.addConversationUnresolvedListener(this.receiveUnresolvedConversation)
    this.getConversations()
  },

  methods: {
    ...mapGetters('socketx', [
      'getConversations'
    ]),
    ...mapActions('socketx', [
      'addConversationListListener',
      'addConversationNewListener',
      'addMessageNewListener',
      'addConversationRemoveListener',
      'addConversationResolvedListener',
      'addConversationUnresolvedListener',
      'setConversationSelectedIdentifier'
    ]),

    conversationUnread (con) {
      if (con.unreadMessage || con.newConversation) { return '--bold' }
      return ''
    },

    createMessage (message) {
      if(this.isBlank(message)) { return }
      App.conversation.speak('user', message)
    },

    highlightConversation (con) {
      return con.selected == true ? '--bgLight --dark' : ''
    },

    indicatorIcon (con) {
      if (con.resolved) { return 'fa-times'}
      if (con.typing) { return 'fa-ellipsis-h'}
      if (con.unreadMessage || con.newConversation) { return 'fa-exclamation'}
      return
    },

    indicatorColor (con) {
      if (con.resolved) { return }
      if (con.typing) { return '--yellow' }
      if (con.unreadMessage || con.newConversation) { return '--red' }
      return '--green'
    },

    receiveConversations (conversations) {
      this.conversations = conversations.map((con) => {
        return {
          alias: con.name,
          identifier: con.identifier,
          newConversation: false,
          mobile: con.mobile,
          typing: false,
          unreadMessage: false,
          selected: false,
          resolved: con.closedAt != null
        }
      })
    },

    receiveNewConversation (conversation) {
      this.conversations.unshift({
        alias: conversation.name,
        identifier: conversation.identifier,
        newConversation: true,
        mobile: conversation.mobile,
        typing: false,
        unreadMessage: false,
        selected: false,
        resolved: conversation.closedAt != null
      })
    },

    receiveNewMessage (message) {
      this.receiveUnresolvedConversation({ identifier: message.conversationIdentifier })
      if(this.selectedConversation.identifier != message.conversationIdentifier) {
        const rcon = this.conversations.find(con => con.identifier == message.conversationIdentifier)
        if(this.isBlank(rcon)) { return }
        rcon.newConversation = true
      }
    },

    receiveRemoveConversation (conversation) {
      this.conversations = this.conversations.filter(con => con.identifier != conversation.identifier)
    },

    receiveResolvedConversation (conversation) {
      const rcon = this.conversations.find(con => con.identifier == conversation.identifier)
      if(this.isBlank(rcon)) { return }
      rcon.resolved = true
    },

    receiveUnresolvedConversation (conversation) {
      const rcon = this.conversations.find(con => con.identifier == conversation.identifier)
      if(this.isBlank(rcon)) { return }
      rcon.resolved = false
    },

    selectConversation (conversation) {
      /*
       * Do not reload the same conversation
       * console.log('Clicked')
       */
      if(!this.isBlank(this.selectedConversation) && this.selectedConversation.identifier == conversation.identifier) { return }
      this.selectedConversation = conversation
      this.conversations.forEach((con) => con.selected = false)
      conversation.newConversation = false
      conversation.selected = true
      this.$router.push({ name: 'messages' })
      this.setConversationSelectedIdentifier(conversation.identifier)
    }
  }
}
/* eslint-enable no-undef */

</script>

<style scoped lang="scss">
@import '~@styles/abstracts/variables';

.conversation {
  display: flex;
  align-items: center;
  padding: 6px 0;
  cursor: pointer;
}
.conversation__name {
  margin-right: 12px;
}
.conversation__mobileIcon {
  font-size: 1.5rem;
  color: $white;
}
.conversation__indicator {
  height: 20px;
  width: 20px;
  margin-right: 12px;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  .conversation__indicatorIcon {
    color: $white;
    font-size: .8rem;
  }
}

.conversation.--bgLight{
  margin: 0 -30px;
  padding: 6px 30px;
}
// .fade-enter-active, .fade-leave-active {
//   transition: opacity .5s
// }
// .fade-enter, .fade-leave-to /* .fade-leave-active below version 2.1.8 */ {
//   opacity: 0
// }
// .conversation-list {
//   background-color: #fff;
//   height: 80vh;
//   overflow-y: scroll;
// }
//
// .conversation-preview {
//   border-top: 1px solid #3d3d3d;
// }
//
// .conversation-preview-active {
//   background-color: #a7cdff;
//   border: 1px solid #3d3d3d;
// }
//
// .conversation-preview:hover {
//   background-color: #c8dffd;
// }
</style>
