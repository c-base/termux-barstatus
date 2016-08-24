module.exports =
  broker: process.env.MQTT_BROKER or 'mqtt://10.0.1.17'
  topic: 'bar/state'
  command: 'termux-notification'
