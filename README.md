# Docker image containing ActiveMQ
Basic Docker image to run activemq as user app (999:999)

You need edit (add) this env:
- **STORE_USAGE**: value in GB (default value is 10)
- **TEMP_USAGE**: value in GB (default value is 5)
- **ADMIN_PASSWORD**: provide admin password (default admin123)
- **PORT_OPENWIRE**: port for openwire connection (default value is 61616)
- **PORT_AMQP**: port for AMQP connection (default value is 5672)
- **PORT_STOMPSSL**: port for stomp/SSL connection (default value is 61612)
- **PORT_STOMP**: port for stomp connection (default value is 61613)
- **PORT_MQTT**: port for MQTT connection (default value is 1883)
- **PORT_WS**: port for WebSocket connection (default value is 61614)

If you want web console you should expose:
- **8161**: if you need plain http connection
- **8162**: if you need ssl connection
