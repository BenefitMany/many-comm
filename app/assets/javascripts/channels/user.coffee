App.user = App.cable.subscriptions.create "UserChannel",
  connected: ->
    # console.log '################################################'
    # console.log 'Server UserChannel connected: Here in coffee script'
    # console.log '################################################'
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # console.log '################################################'
    # console.log 'Server UserChannel disconnected: Here in coffee script'
    # console.log '################################################'
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # console.log '################################################'
    # console.log 'Server UserChannel received (data): Here in coffee script', data
    # console.log '################################################'
    # Called when there's incoming data on the websocket for this channel
