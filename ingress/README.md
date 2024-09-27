
# Nginx ingress

```
helm upgrade --install ingress-nginx ingress-nginx \
  --set "controller.service.type=ClusterIP" \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

# Tunnel
replace `USER` and `TUNNEL_ID`:

```
cloudflared tunnel login
cloudflared tunnel create test-tunnel

kubectl create namespace tunnel 
kubectl create secret generic test-tunnel \
  -n tunnel \
  --from-file=credentials.json=/Users/<USER>/.cloudflared/<TUNNEL_ID>.json

kubectl apply -f tunnel.yaml
```

Create Cloduflare DNS record:
replace `ZONE_ID`, `TUNNEL_ID`, `API_TOKEN` and `SUBDOMAIN`

```
curl --request POST \
  --url https://api.cloudflare.com/client/v4/zones/<ZONE_ID>/dns_records \
  --header 'Content-Type: application/json' \
  --header 'Authorization: Bearer <API_TOKEN>' \
  --data '{
    "comment": "",
    "name": "<SUBDOMAIN>",
    "proxied": true,
    "settings": {},
    "tags": [],
    "ttl": 3600,
    "content": "<TUNNEL_ID>.cfargotunnel.com",
    "type": "CNAME"
  }'
```


