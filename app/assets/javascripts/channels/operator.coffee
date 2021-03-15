App.operator = App.cable.subscriptions.create "OperatorChannel",
  connected: ->
    # console.log '################################################'
    # console.log 'Server OperatorChannel connected: Here in coffee script'
    # console.log '################################################'
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # console.log '################################################'
    # console.log 'Server OperatorChannel disconnected: Here in coffee script'
    # console.log '################################################'
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # console.log '################################################'
    # console.log 'Server OperatorChannel received (data): Here in coffee script', data
    # console.log '################################################'
    # Called when there's incoming data on the websocket for this channel
