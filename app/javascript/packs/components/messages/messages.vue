<template>
  <div class="stickyContainer">
    <div v-show="showMessages" class="stickyContainer">
      <div class="mcContainer">
        <div class="header">
          <h1 class="header__name">
            {{ visitorName }} Chat
          </h1>
          <div class="header__initiated">
            <span class="--bold">Initiated: </span><span>{{ firstMessageDate | dateMMDDYYHHMM }}</span>
          </div>
          <button v-if="selectedConversationResolved" type="button" name="button" class="btn-solid" @click.prevent="unresolvedConversation()">
            Unresolve Chat
          </button>
          <button v-else type="button" name="button" class="btn-solid" @click.prevent="resolvedConversation()">
            Resolve Chat
          </button>
        </div>
      </div>

      <div class="scrollContainer">
        <div id="many-comm-message-container" class="mcContainer">
          <div v-for="(message, mIndx) in selectedConversationMessages" :key="mIndx" class="chatBlock" :class="[messageFromVisitor(message) ? 'chatBlock--left' : 'chatBlock--right' ]">
            <img :src="messageFromVisitor(message) ? '/user.svg' : '/mc-avatar.svg'" class="chatBlock__avatar">
            <div class="chatBlock__data">
              <div class="chatBlock__name">
                {{ message.name }}
              </div>
              <div class="chatBlock__timestamp">
                {{ message.createdAt | dateMMDDYYHHMM }}
              </div>
              <div class="chatBlock__message">
                {{ message.message }}
              </div>
            </div>
          </div>
          <div id="anchor-name" style="position: relative; margin-top: 200px; top: 200px; left: 0"/>
          <!-- Anchor used to scroll to the bottom of this div see scrollBottom method -->
        </div>
      </div>
      <div class="mcContainer sendMessageBlock">
        <div class="messageArea">
          <div id="typingMessageContent" class="messageArea__input" contenteditable @keyup.enter.exact="createMessage" @input="newMessageInput"/>
          <button class="messageArea__btn btn-solid" @click.prevent="createMessage">
            Send<i class="fa fa-send"/>
          </button>
        </div>
        <p class="text-muted">
          Enter to Send, Ctrl + Enter for new line
        </p>
      </div>
    </div>
    <div v-show="noCurrentChats" class="p-5">
      <app-blank-slate/>
    </div>
    <div v-show="conversationGoneAway" class="p-5">
      <app-conversation-gone-away/>
    </div>
  </div>
</template>

<script>
import BlankSlate from './blank_slate.vue'
import ConversationGoneAway from './conversation_gone_away.vue'
import { mapActions } from 'vuex'

export default {
  components: {
    'app-blank-slate': BlankSlate,
    'app-conversation-gone-away': ConversationGoneAway
  },
  data: function () {
    return {
      selectedConversationIdentifier: null,
      selectedConversationResolved: false,
      selectedConversationMessages: [],
      newMessage: ''
    }
  },

  computed: {
    conversationGoneAway () {
      // Messages existed, but conversation went away.
      return !this.noCurrentChats && this.isBlank(this.selectedConversationIdentifier)
    },

    firstMessageDate () {
      if(this.noCurrentChats) {
        return new Date()
      }
      return this.selectedConversationMessages[0].createdAt
    },

    noCurrentChats () {
      return this.selectedConversationMessages.length == 0
    },

    showMessages () {
      return this.selectedConversationMessages.length > 0 && !this.isBlank(this.selectedConversationIdentifier)
    },

    visitorName () {
      if(this.noCurrentChats) { return 'loading...' }
      return this.selectedConversationMessages[0].name
    }
  },

  created () {
    this.addConversationChangeListener(this.fetchConversationMessages)
    this.addMessagesListListener(this.receiveMessageList)
    this.addConversationRemoveListener(this.receiveRemoveConversation)
    this.addConversationSelectedNewMessageListener(this.receiveNewMessage)
    this.getMessages()
  },

  methods: {
    ...mapActions('socketx',[
      'addConversationChangeListener',
      'addMessagesListListener',
      'addConversationRemoveListener',
      'addConversationSelectedNewMessageListener',
      'getMessages',
      'sendMessage',
      'conversationResolved',
      'conversationUnresolved'
    ]),

    createMessage () {
      this.sendMessage(this.newMessage)
      document.getElementById('typingMessageContent').innerHTML = ''
      this.newMessage = ''
      this.scrollBottom()
    },

    fetchConversationMessages () {
      this.getMessages()
      this.scrollBottom()
    },

    messageFromVisitor (message) {
      return message.messageFrom == 'Visitor'
    },

    newMessageInput (e) {
      this.newMessage = e.target.innerText
    },

    receiveMessageList (messageList) {
      this.selectedConversationIdentifier = messageList.conversation.identifier
      this.selectedConversationResolved = !this.isBlank(messageList.conversation.closedAt)
      this.selectedConversationMessages = messageList.messages.map((msg) => {
        return {
          name: msg.name,
          messageFrom: msg.messageFrom,
          message: msg.message,
          createdAt: msg.createdAt
        }
      })
      this.scrollBottom()
    },

    receiveNewMessage (message) {
      this.selectedConversationResolved = false
      this.selectedConversationMessages.push({
        name: message.name,
        messageFrom: message.messageFrom,
        message: message.message,
        createdAt: message.createdAt
      })
      this.scrollBottom()
    },

    receiveRemoveConversation (conversation) {
      if(this.selectedConversationIdentifier == conversation.identifier) {
        this.selectedConversationIdentifier = null
      }
    },

    resolvedConversation () {
      this.selectedConversationResolved = true
      this.conversationResolved()
    },

    unresolvedConversation () {
      this.selectedConversationResolved = false
      this.conversationUnresolved()
    },

    scrollBottom () {
      const element = document.getElementById('anchor-name')
      element.scrollIntoView({ behavior: 'smooth', block: 'start' })
    }
  }
}
</script>

<style scoped lang="scss">
@import '~@styles/abstracts/variables';

.header {
  height: 75px;
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid #1C2022;
  .header__name {

  }
  .header__initiated {

  }
  .header__resolve {

  }
}

.messageArea {
  display: flex;
  position: relative;
  .messageArea__input {
    width: 300px;
    min-height: 40px;
    border: 1px solid #ccc;
    max-height: 150px;
    overflow-x: hidden;
    overflow-y: auto;
    flex: 1;
    border-radius: 4px;
    border-style: solid;
    border-color: #a5a5a5;
    border-width: 1px;
    padding-right: 100px;
    padding-left: 12px;
  }
  .messageArea__btn {
    position: absolute;
    right: 4px;
    bottom: -10px;
    transform: translateY(-50%);
    i {
      padding-left: 10px;
    }
  }
}


.chatBlock {
  display: flex;
  margin-top: 20px;
  &:last-of-type {
    margin-bottom: 40px;
  }
}
.chatBlock__message {
  margin-top: 12px;
  padding: 16px 20px;
  border-radius: 4px;
}

.chatBlock--left {
  padding-right: 20%;
  .chatBlock__avatar {
    border-radius: 50%;
    max-width: 40px;
    max-height: 40px;
    margin-right: 12px;
  }
  .chatBlock__data {

  }

  .chatBlock__message {
    background-color: #E7E9EA;
  }
}

.chatBlock--right {
  padding-left: 20%;
  flex-direction: row-reverse;

  .chatBlock__avatar {
    border-radius: 50%;
    max-width: 40px;
    max-height: 40px;
    margin-left: 12px;
  }
  .chatBlock__data {

  }
  .chatBlock__name {
    text-align: right;
  }
  .chatBlock__timestamp {
    text-align: right;
  }
  .chatBlock__message {
    background-color: #D8E4E8;
  }
}

.chatBlock__name {
  font-weight: $bold;
}
.chatBlock__timestamp {
  color: $secondary;
  font-size: .85rem;
}
.chatBlock__message {
  font-weight: $light;
}

</style>
