# Docker image containing ActiveMQ
Basic Docker image to run activemq as user app (499:499)

You need edit (add) this env:

*General*

- **STORE_USAGE**: value in GB (default value is `10`)
- **TEMP_USAGE**: value in GB (default value is `5`)
- **ADMIN_PASSWORD**: provide admin password (default `admin123`)
- **KEYSTORE_LOCATION**: location of keystore (default `\/opt\/app\/broker.ks`) - remember to escape special chars
*Networking*

- **ACTIVE_MQ_TRANSPORT_CONNECTOR_NAMES**: available values **OPENWIRE,AMQP,MQTT,STOMP,STOMPSSL,WS,SSL**
- **ACTIVE_MQ_TRANSPORT_CONNECTOR_WS_PORT**: port for WS connector (default value 61614)
- **ACTIVE_MQ_TRANSPORT_CONNECTOR_OPENWIRE_PORT**: port for OPENWIRE connector (default value 61616)
- **ACTIVE_MQ_TRANSPORT_CONNECTOR_SSL_KEYSTOREPASSWORD**: password for keystore file
- **ACTIVE_MQ_TRANSPORT_CONNECTOR_SSL_TRUSTSTOREPASSWORD**: pasword for truststore file
- **ACTIVE_MQ_TRANSPORT_CONNECTOR_SSL_PORT**: port for SSL connector (default value 61617)
- **ACTIVE_MQ_TRANSPORT_CONNECTOR_MQTT_PORT**: port for MQTT connector (default value 1883)
- **ACTIVE_MQ_TRANSPORT_CONNECTOR_AMQP_PORT**: port for AMQP connector (default value 5672)
- **ACTIVE_MQ_TRANSPORT_CONNECTOR_STOMP_PORT**: port for STOMP connector (default value 61613)
- **ACTIVE_MQ_TRANSPORT_CONNECTOR_STOPMSSL_PORT** port for STOMPSSL connector (default value 61612)
- **NETWORK_OF_BROKERS_CONNECTORS_URI**: possibility to configure network of brokers. As this env variable is part of `sed` command it needs to escape all special characters like in `sed` f.e.:

```export NETWORK_OF_BROKERS_CONNECTORS_URI=static:(tcp:\/\/10.122.17.157:61616)```

*Logging:*

- **ROOT_LOGGER_LEVEL** - changes `log4j.rootLogger` (default value: `INFO, console, logfile`)
- **ACTIVEMQ_SPRING_LOGGER_LEVEL** - changes `log4j.logger.org.apache.activemq.spring` (default value: `WARN`)
- **ACTIVEMQ_WEB_HANDLER_LOGGER_LEVEL** - changes `log4j.logger.org.apache.activemq.web.handler` (default value: `WARN`)
- **SPRINGFRAMEWORK_LOGGER_LEVEL** - changes `log4j.logger.org.springframework` (default value: `WARN`)
- **CAMEL_LOGGER_LEVEL** - changes `log4j.logger.org.apache.camel` (default value: `INFO`)
- **CONSOLE_APPENDER_THRESHOLD_LEVEL** - changes `log4j.appender.console.threshold` (default value: `INFO`)

If you want web console you should expose:
- **8161**: if you need plain http connection
- **8162**: if you need ssl connection
