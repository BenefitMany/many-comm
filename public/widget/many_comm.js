ManyComm = {
  defaults: {
    'appDomain': 'localhost:3000',
    'socketDomain': null,
    'secureUrl': false,
    'accessKey': '',
    'primaryColor': '',
    'primaryColorText': '',
    'secondaryColor': '',
    'secondaryColorText': ''
  },

  manyCommSocket: '',
  messageIndex: -1,
  visitorIdentifier: 'UNKNOWN',

  start: function (options) {
    if(options !== undefined) {
      $.extend(this.defaults, options)
      const newStyles = document.createElement('style')
      document.head.append(newStyles)

      // STYLES DEFINED IN THE CSS
      if(options.primaryColor) { document.body.style.setProperty('--primary-color', options.primaryColor) }
      if(options.primaryColorText) { document.body.style.setProperty('--primary-color-text', options.primaryColorText) }
      if(options.secondaryColor) { document.body.style.setProperty('--secondary-color', options.secondaryColor) }
      if(options.secondaryColorText) { document.body.style.setProperty('--secondary-color-text', options.secondaryColorText) }
    }
    this._initDisplay()
  },

  // Private functions

  _appUrl: function () {
    var secureUrl = this.defaults.secureUrl ? 'https://' : 'http://';
    return secureUrl + this.defaults.appDomain;
  },

  _socketUrl: function () {
    var secureUrl = this.defaults.secureUrl ? 'wss://' : 'ws://';
    if(this.defaults.socketDomain == null) {
      return secureUrl + this.defaults.appDomain + '/cable';
    }
    return secureUrl + this.defaults.socketDomain;
  },

  _loadVisitorIdentifier: function () {
    this.visitorIdentifier = this._getVisitorCookie()
    if(this.visitorIdentifier == undefined) {
      this.visitorIdentifier = this._setVisitorCookie()
    }
  },

  _startConnection: function () {
    this._loadVisitorIdentifier()
    this._initManyComm()
  },

  _sendMessage: function (message) {
    this.manyCommSocket.send(this._messageEnvelop(message))
  },

  _closeConnection: function () {
    // this.manyCommSocket.send(this._disconnectEnvelop());
    this.manyCommSocket.close()
    this._clearMessages()
  },

  _initDisplay: function () {
    // this._initLibs()
    this._initStyles()
    this._initUI()
    this._initUIListeners()
  },

  _initLibs: function () {
    const cssLink = document.createElement('link')
    cssLink.setAttribute('rel', 'stylesheet')
    cssLink.setAttribute('type', 'text/css')
    (document.getElementsByTagName('head')[0] || document.documentElement).appendChild(cssLink)
  },

  _initStyles: function () {
    const cssLink = document.createElement('link')
    cssLink.setAttribute('rel', 'stylesheet')
    cssLink.setAttribute('type', 'text/css')
    cssLink.setAttribute('href', this._appUrl() + '/widget/many_comm.css');
    (document.getElementsByTagName('head')[0] || document.documentElement).appendChild(cssLink)
  },

  _initUI: function () {
    const chatBoxBody = '<div id="many-comm-circle" class="btn btn-raised"> \
                         <div id="many-comm-overlay"></div> \
                         <i class="material-icons">chat</i> \
                       </div> \
                       <div id="many-comm-box" class="many-comm-hidden"> \
                         <div class="many-comm-box-header"> \
                           ManyComm \
                           <span id="many-comm-box-toggle"><i class="material-icons">close</i></span> \
                         </div> \
                         <div class="many-comm-box-body"> \
                           <div class="many-comm-box-overlay"></div> \
                           <div id="many-comm-logs"></div> \
                         </div> \
                         <div class="many-comm-input"> \
                           <form> \
                             <input type="text" id="many-comm-input" placeholder="Send a message..."/> \
                             <button type="submit" class="many-comm-submit" id="many-comm-submit"> \
                               <i class="material-icons">send</i> \
                             </button> \
                           </form> \
                         </div> \
                       </div>'
    const chatBox = document.createElement('div')
    chatBox.setAttribute('id', 'many-comm-body')
    chatBox.innerHTML = chatBoxBody;
    (document.getElementsByTagName('body')[0] || document.documentElement).appendChild(chatBox)
  },

  _initUIListeners: function () {
    const self = this

    this._click('many-comm-circle', function () {
      self._toggle('many-comm-circle', 'many-comm-hidden')
      self._toggle('many-comm-box', 'many-comm-hidden')
      self._startConnection()
    })

    this._click('many-comm-box-toggle', function () {
      self._toggle('many-comm-circle', 'many-comm-hidden')
      self._toggle('many-comm-box', 'many-comm-hidden')
      self._closeConnection()
      const elem = document.getElementById('many-comm-input')
      elem.value = ''
    })

    this._click('many-comm-submit', function (e) {
      e.preventDefault()
      const elem = document.getElementById('many-comm-input')
      const msg = elem.value
      if(msg.trim() == '') { return false }
      self._sendMessage(msg)
      elem.value = ''
    })
  },

  _initManyComm: function () {
    const self = this
    this.manyCommSocket = new WebSocket(this._socketUrl() + '?visitor=' + this.defaults.accessKey)
    this.manyCommSocket.onopen = function (event) {
      self.manyCommSocket.send(self._connectionEnvelop())
    }
    this.manyCommSocket.onmessage = function (event) {
      const data = JSON.parse(event.data)
      if(data.message == undefined || data.type == 'ping') { return }
      self._displayMessage(data.message.newMessage.message, data.message.newMessage.messageFrom)
    }
    this.manyCommSocket.onclose = function (event) {
      if(self._chatbox_showing()) {
        setTimeout(function () { self._initManyComm() }, 5000)
      }
    }
    this.manyCommSocket.onerror = function (event) {
      console.log('Disconnected open chatbox.... will try to reconnect in 5 seconds.')
    }
  },

  _clearMessages: function () {
    Array.from(document.getElementsByClassName('many-comm-msg')).forEach(element => element.remove())
    this.messageIndex = -1
  },

  _displayMessage: function (msg, type) {
    this.messageIndex++
    const msgContainer = document.createElement('div')
    msgContainer.setAttribute('id', 'many-comm-msg-' + this.messageIndex)
    msgContainer.setAttribute('class', 'many-comm-msg ' + type.toLowerCase())

    const userMessage = document.createElement('div')
    userMessage.setAttribute('class', 'many-comm-msg-text')
    userMessage.innerHTML = msg

    /*
     * const typeSignature = document.createElement('div')
     * typeSignature.setAttribute('class', 'many-comm-msg-signature')
     * typeSignature.innerHTML = type.toLowerCase()
     */

    // msgContainer.appendChild(typeSignature)
    msgContainer.appendChild(userMessage)

    document.getElementById('many-comm-logs').appendChild(msgContainer)
    if(type == 'visitor') { document.getElementById('many-comm-input').value = '' }

    // Jump to the bottom
    const objDiv = document.getElementById('many-comm-logs')
    objDiv.scrollTop = objDiv.scrollHeight
  },

  _connectionEnvelop: function () {
    return JSON.stringify({
      'command': 'subscribe',
      'identifier': JSON.stringify({
        'channel': 'VisitorChannel',
        'conversation': this.visitorIdentifier
      })
    })
  },

  _messageEnvelop: function (message) {
    return JSON.stringify({
      'command': 'message',
      'identifier': JSON.stringify({
        'channel': 'VisitorChannel',
        'conversation': this.visitorIdentifier
      }),
      'data': JSON.stringify({
        'action': 'speak',
        'method': 'new_message',
        'message': message
      })
    })
  },

  /*
   * _disconnectEnvelop: function () {
   *   return JSON.stringify({
   *     "command": "unsubscribe",
   *     "identifier": JSON.stringify({"channel": "VisitorChannel", "conversationIdentifier" : this.visitorIdentifier})
   *   })
   * },
   */

  _chatbox_showing: function () {
    return !document.getElementById('many-comm-box').classList.contains('many-comm-hidden')
  },

  _click: function (domId, callback) {
    document.getElementById(domId).addEventListener('click', callback)
  },

  _toggle: function (domId, className) {
    document.getElementById(domId).classList.toggle(className)
  },

  _setVisitorCookie: function () {
    const d = new Date()
    d.setTime(d.getTime() + (356*24*60*60*1000))
    const vid = [d.getTime(), this._guid()].join('::')
    document.cookie = 'manycomm=' + vid + ';expires=' + d.toUTCString() + ';path=/'
    return vid
  },

  _getVisitorCookie: function () {
    const re = new RegExp('manycomm=([^;]+)')
    const value = re.exec(document.cookie)
    return (value == undefined) ? undefined : decodeURI(value[1])
  },

  _deleteVisitorCookie: function () {
    document.cookie = 'manycomm=;expires=Thu, 01 Jan 1970 00:00:01 GMT;'
  },

  _guid: function () {
    return this._s4() + this._s4() + '-' +
           this._s4() + '-' + this._s4() + '-' +
           this._s4() + '-' + this._s4() + this._s4() +
           this._s4()
  },

  _s4: function () {
    return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1)
  }
}
