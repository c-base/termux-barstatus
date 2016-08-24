config = require '../config.coffee'
mqtt = require 'mqtt'
{exec} = require 'child_process'
escape = require 'shell-escape'

exports.connect = (callback) ->
  client = mqtt.connect config.broker
  client.on 'connect', ->
    return unless callback
    callback null, client
    callback = null
  client.on 'error', (err) ->
    return unless callback
    callback err
    callback = null

main = ->
  previousState = null #'closed'
  exports.connect (err, client) ->
    if err
      console.error err
      process.exit 1
    client.subscribe config.topic
    client.on 'message', (topic, msg) ->
      message = msg.toString()
      return if message is previousState
      console.log "Bar is #{message}"
      previousState = message
      exec escape [
        config.command
        '-c'
        "Bar is #{message}"
        '-t'
        'c-base'
      ]
      , (err) ->
        if err
          console.error err
          process.exit 1
        return

main() unless module.parent
