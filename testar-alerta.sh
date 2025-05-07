#!/bin/bash

RABBIT_HOST="localhost"
RABBIT_USER="admin"
RABBIT_PASS="admin"
QUEUE="teste-alerta"

echo "[1/3] Criando a fila '$QUEUE'..."
curl -u "$RABBIT_USER:$RABBIT_PASS" -X PUT \
  -H "content-type: application/json" \
  -d '{"durable":true}' \
  "http://$RABBIT_HOST:15672/api/queues/%2F/$QUEUE"

echo "[2/3] Publicando 150 mensagens na fila '$QUEUE'..."
for i in $(seq 1 150); do
  curl -s -u "$RABBIT_USER:$RABBIT_PASS" -X POST \
    -H "content-type: application/json" \
    -d '{"properties":{},"routing_key":"'"$QUEUE"'","payload":"mensagem '"$i"'","payload_encoding":"string"}' \
    "http://$RABBIT_HOST:15672/api/exchanges/%2F/amq.default/publish" > /dev/null
done

echo "[3/3] Mensagens publicadas. Aguarde 1 a 2 minutos e verifique o alerta no Grafana."

