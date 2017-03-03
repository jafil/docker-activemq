#!/bin/bash
set -e
set -x

#check if connector types are set
if [ -z ${ACTIVE_MQ_TRANSPORT_CONNECTOR_NAMES} ]; 
   then echo "Configuration error: 'ACTIVE_MQ_TRANSPORT_CONNECTOR_NAMES' env variable is not set";
   exit 0  
fi

STORE_USAGE=${STORE_USAGE:=10}
TEMP_USAGE=${TEMP_USAGE:=5}
ADMIN_PASSWORD=${ADMIN_PASSWORD:=admin123}

ROOT_LOGGER_LEVEL=${ROOT_LOGGER_LEVEL:="INFO, console, logfile"}
ACTIVEMQ_SPRING_LOGGER_LEVEL=${ACTIVEMQ_SPRING_LOGGER_LEVEL:="WARN"}
ACTIVEMQ_WEB_HANDLER_LOGGER_LEVEL=${ACTIVEMQ_WEB_HANDLER_LOGGER_LEVEL:="WARN"}
SPRINGFRAMEWORK_LOGGER_LEVEL=${SPRINGFRAMEWORK_LOGGER_LEVEL:="WARN"}
CAMEL_LOGGER_LEVEL=${CAMEL_LOGGER_LEVEL:="INFO"}
CONSOLE_APPENDER_THRESHOLD_LEVEL=${CONSOLE_APPENDER_THRESHOLD_LEVEL:="INFO"}

sed -i -e "s/<storeUsage limit=\"100 gb\"\/>/<storeUsage limit=\"${STORE_USAGE} gb\"\/>/" /opt/app/apache-activemq/conf/activemq.xml
sed -i -e "s/<tempUsage limit=\"50 gb\"\/>/<tempUsage limit=\"5 gb\"\/>/" /opt/app/apache-activemq/conf/activemq.xml

#Checking transport connectors
IFS=', ' read -r -a ACTIVE_MQ_TRANSPORT_CONNECTOR_NAMES_ARRAY <<< "${ACTIVE_MQ_TRANSPORT_CONNECTOR_NAMES}"

for CONNECTOR in "${ACTIVE_MQ_TRANSPORT_CONNECTOR_NAMES_ARRAY[@]}"
do
	#CHECK OPENWIRE
	if [ "$CONNECTOR" == 'OPENWIRE' ] ; then
		OPENWIRE_CONNECTOR='true'	
	fi


	#CHECK AMQP
	if [ "$CONNECTOR" == 'AMQP' ] ; then
		AMQP_CONNECTOR='true'	
	fi

	#CHECK STOPMSSL
	if [ "$CONNECTOR" == 'STOMPSSL' ] ; then
		STOMPSSL_CONNECTOR='true'	
	fi

	#CHECK STOMP
	if [ "$CONNECTOR" == 'STOMP' ] ; then
		STOMP_CONNECTOR='true'	
	fi

	#CHECK MQTT
	if [ "$CONNECTOR" == 'MQTT' ] ; then
		MQTT_CONNECTOR='true'	
	fi

	#CHECK WS
	if [ "$CONNECTOR" == 'WS' ] ; then
		WS_CONNECTOR='true'	
	fi

	#CHECK SSL
	if [ "$CONNECTOR" == 'SSL' ] ; then
		SSL_CONNECTOR='true'	
	fi
done

if [ -n "$OPENWIRE_CONNECTOR" ] ; then
    PORT_OPENWIRE=${ACTIVE_MQ_TRANSPORT_CONNECTOR_OPENWIRE_PORT:=61616}
    sed -i "s/<transportConnector name=\"openwire\" uri=\"tcp:\/\/0.0.0.0:61616?maximumConnections=1000\&amp;wireFormat.maxFrameSize=104857600\"\/>/<transportConnector name=\"openwire\" uri=\"tcp:\/\/0.0.0.0:${PORT_OPENWIRE}\?maximumConnections=1000\&amp;wireFormat.maxFrameSize=104857600\"\/>/g" /opt/app/apache-activemq/conf/activemq.xml
    echo "OPENWIRE CONNECTOR SET"
else
    sed -i "s/<transportConnector name=\"openwire\" uri=\"tcp:\/\/0.0.0.0:61616?maximumConnections=1000\&amp;wireFormat.maxFrameSize=104857600\"\/>//g" /opt/app/apache-activemq/conf/activemq.xml
fi


if [ -n "$AMQP_CONNECTOR" ] ; then
    PORT_AMQP=${ACTIVE_MQ_TRANSPORT_CONNECTOR_AMQP_PORT:=5672}
    sed -i "s/<transportConnector name=\"amqp\" uri=\"amqp:\/\/0.0.0.0:5672?maximumConnections=1000\&amp;wireFormat.maxFrameSize=104857600\"\/>/<transportConnector name=\"amqp\" uri=\"amqp:\/\/0.0.0.0:${PORT_AMQP}\?maximumConnections=1000\&amp;wireFormat.maxFrameSize=104857600\"\/>/g" /opt/app/apache-activemq/conf/activemq.xml
    echo "AMQP CONNECTOR SET"
else
    sed -i "s/<transportConnector name=\"amqp\" uri=\"amqp:\/\/0.0.0.0:5672?maximumConnections=1000\&amp;wireFormat.maxFrameSize=104857600\"\/>//g" /opt/app/apache-activemq/conf/activemq.xml
fi

if [ -n "$STOMPSSL_CONNECTOR" ] ; then
    PORT_STOMPSSL=${ACTIVE_MQ_TRANSPORT_CONNECTOR_STOMPSSL_PORT:=61612}
    sed -i -e "s/<transportConnector name=\"stompssl\" uri=\"stomp+nio+ssl:\/\/0.0.0.0:61612?transport.enabledCipherSuites=SSL_RSA_WITH_RC4_128_SHA,SSL_DH_anon_WITH_3DES_EDE_CBC_SHA\" \/>/<transportConnector name=\"stompssl\" uri=\"stomp+nio+ssl:\/\/0.0.0.0:${PORT_STOMPSSL}\?transport.enabledCipherSuites=SSL_RSA_WITH_RC4_128_SHA,SSL_DH_anon_WITH_3DES_EDE_CBC_SHA\" \/>/g" /opt/app/apache-activemq/conf/activemq.xml 
    echo "STOMPSSL CONNECTOR SET"
else
    sed -i -e "s/<transportConnector name=\"stompssl\" uri=\"stomp+nio+ssl:\/\/0.0.0.0:61612?transport.enabledCipherSuites=SSL_RSA_WITH_RC4_128_SHA,SSL_DH_anon_WITH_3DES_EDE_CBC_SHA\" \/>//g" /opt/app/apache-activemq/conf/activemq.xml
fi

if [ -n "$STOMP_CONNECTOR" ] ; then
    PORT_STOMP=${ACTIVE_MQ_TRANSPORT_CONNECTOR_STOMP_PORT:=61613}
    sed -i -e "s/<transportConnector name=\"stomp\" uri=\"stomp:\/\/0.0.0.0:61613?maximumConnections=1000\&amp;wireFormat.maxFrameSize=104857600\"\/>/<transportConnector name=\"stomp\" uri=\"stomp:\/\/0.0.0.0:${PORT_STOMP}\?maximumConnections=1000\&amp;wireFormat.maxFrameSize=104857600\"\/>/g" /opt/app/apache-activemq/conf/activemq.xml
    echo "STOMP CONNECTOR SET"
else
    sed -i -e "s/<transportConnector name=\"stomp\" uri=\"stomp:\/\/0.0.0.0:61613?maximumConnections=1000\&amp;wireFormat.maxFrameSize=104857600\"\/>//g" /opt/app/apache-activemq/conf/activemq.xml
fi

if [ -n "$MQTT_CONNECTOR" ] ; then
    PORT_MQTT=${ACTIVE_MQ_TRANSPORT_CONNECTOR_MQTT_PORT:=1883}
    sed -i "s/<transportConnector name=\"mqtt\" uri=\"mqtt:\/\/0.0.0.0:1883?maximumConnections=1000\&amp;wireFormat.maxFrameSize=104857600\"\/>/<transportConnector name=\"mqtt\" uri=\"mqtt:\/\/0.0.0.0:${PORT_MQTT}\?maximumConnections=1000\&amp;wireFormat.maxFrameSize=104857600\"\/>/g" /opt/app/apache-activemq/conf/activemq.xml
    echo "MQTT CONNECTOR SET"
else
    sed -i -e "s/<transportConnector name=\"mqtt\" uri=\"mqtt:\/\/0.0.0.0:1883?maximumConnections=1000\&amp;wireFormat.maxFrameSize=104857600\"\/>//g" /opt/app/apache-activemq/conf/activemq.xml
fi

if [ -n "$WS_CONNECTOR" ] ; then
    PORT_WS=${ACTIVE_MQ_TRANSPORT_CONNECTOR_WS_PORT:=61614}
    sed -i "s/<transportConnector name=\"ws\" uri=\"ws:\/\/0.0.0.0:61614?maximumConnections=1000\&amp;wireFormat.maxFrameSize=104857600\"\/>/<transportConnector name=\"ws\" uri=\"ws:\/\/0.0.0.0:${PORT_WS}\?maximumConnections=1000\&amp;wireFormat.maxFrameSize=104857600\"\/>/g" /opt/app/apache-activemq/conf/activemq.xml
    echo "WS CONNECTOR SET"
else
    sed -i "s/<transportConnector name=\"ws\" uri=\"ws:\/\/0.0.0.0:61614?maximumConnections=1000\&amp;wireFormat.maxFrameSize=104857600\"\/>//g" /opt/app/apache-activemq/conf/activemq.xml
fi

if [ -n "$SSL_CONNECTOR" ] ; then
    PORT_SSL=${ACTIVE_MQ_TRANSPORT_CONNECTOR_SSL_PORT:=61617}
    KEYSTOR_PASSWORD=${ACTIVE_MQ_TRANSPORT_CONNECTOR_SSL_KEYSTOREPASSWORD:=''}
    TRUSTSTORE_PASSWORD=${ACTIVE_MQ_TRANSPORT_CONNECTOR_SSL_TRUSTSTOREPASSWORD:=''}
    sed -i -e "s/<transportConnectors>/<transportConnectors>\n<transportConnector name=\"ssl\" uri=\"ssl:\/\/0.0.0.0:${PORT_SSL}?needClientAuth=true\"\/>\n/g" /opt/app/apache-activemq/conf/activemq.xml
    sed -i -e "s/<transportConnectors>/<sslContext>\n<sslContext keyStore=\"file:\/opt\/app\/broker.ks\" keyStorePassword=\"${KEYSTOR_PASSWORD}\" trustStore=\"file:\/opt\/app\/broker.ts\" trustStorePassword=\"${TRUSTSTORE_PASSWORD}\"\/>\n<\/sslContext>\n\n<transportConnectors>/g" /opt/app/apache-activemq/conf/activemq.xml
    echo "SSL CONNECTOR SET"
fi

# Setting up rootLogger level
sed -i -e "s/log4j.rootLogger=INFO, console, logfile/log4j.rootLogger=${ROOT_LOGGER_LEVEL}/g" /opt/app/apache-activemq/conf/log4j.properties

# Setting up activemq logger level
sed -i -e "s/log4j.logger.org.apache.activemq.spring=WARN/log4j.logger.org.apache.activemq=${ACTIVEMQ_SPRING_LOGGER_LEVEL}/g" /opt/app/apache-activemq/conf/log4j.properties

# Setting up activemq web handler logger level
sed -i -e "s/log4j.logger.org.apache.activemq.web.handler=WARN/log4j.logger.org.apache.activemq.web.handler=${ACTIVEMQ_WEB_HANDLER_LOGGER_LEVEL}/g" /opt/app/apache-activemq/conf/log4j.properties

# Setting up springframework logger level
sed -i -e "s/log4j.logger.org.springframework=WARN/log4j.logger.org.springframework=${SPRINGFRAMEWORK_LOGGER_LEVEL}/g" /opt/app/apache-activemq/conf/log4j.properties

# Setting up camel logger level
sed -i -e "s/log4j.logger.org.apache.camel=INFO/log4j.logger.org.apache.camel=${CAMEL_LOGGER_LEVEL}/g" /opt/app/apache-activemq/conf/log4j.properties

# Setting up console appender threshold
sed -i -e "s/log4j.appender.console.threshold=INFO/log4j.appender.console.threshold=${CONSOLE_APPENDER_THRESHOLD_LEVEL}/g" /opt/app/apache-activemq/conf/log4j.properties

# Enabling Network Of Brokers
if [[ -v NETWORK_OF_BROKERS_CONNECTORS_URI ]]; then
  sed -i -e "s/<\/shutdownHooks>/<\/shutdownHooks>\\n<networkConnectors>\\n<networkConnector uri=\"${NETWORK_OF_BROKERS_CONNECTORS_URI}\"\/>\\n<\/networkConnectors>/g" /opt/app/apache-activemq/conf/activemq.xml
fi

sed -i -e "s/admin activemq/admin ${ADMIN_PASSWORD}/" /opt/app/apache-activemq/conf/jmx.password
sed -i -e "s/admin: admin, admin/admin: ${ADMIN_PASSWORD}, admin/" /opt/app/apache-activemq/conf/jetty-realm.properties
sed -i -e 's/user: user, user//' /opt/app/apache-activemq/conf/jetty-realm.properties

# Enable jmx
USE_JMX=${USE_JMX:="false"}
BROKER_NAME=${BROKER_NAME:="localhost"}
USE_JMX_PORT=${USE_JMX_PORT:="1616"}
USE_JMX_SSL=${USE_JMX:="false"}
JMX_OPTS="-Dcom.sun.management.jmxremote.port=${USE_JMX_PORT} -Dcom.sun.management.jmxremote.ssl=USE_JMX_SSL"
sed -i -e "s/brokerName=\"localhost\"/useJmx=\"${USE_JMX}\" brokerName=\"${BROKER_NAME}\"/" /opt/app/apache-activemq/conf/activemq.xml

JVM_OPTS="-server -verbose:gc -XX:+UseCompressedOops -Xms512m -Xmx512m -XX:MetaspaceSize=64M -XX:MaxMetaspaceSize=64M"

exec java ${JVM_OPTS} ${JMX_OPTS} -Djava.util.logging.config.file=logging.properties -jar /opt/app/apache-activemq/bin/activemq.jar start

