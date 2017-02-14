App.enquiry = App.cable.subscriptions.create "EnquiryChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $("#messages").find(".messages-"+ data['enquiry_id']).append data['message']
    # Called when there's incoming data on the websocket for this channel

  speak: (message) ->
    @perform 'speak', message: message

$(document).on 'keypress', '.new_message', (event) ->
  if event.keyCode is 13
    event.target.values = $(this).serializeArray()
    App.enquiry.speak event.target.values
    event.target.value = ' '
    event.preventDefault()
