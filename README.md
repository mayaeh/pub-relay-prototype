pub-relay
=========

...is a service-type ActivityPub actor that will re-broadcast anything sent to it to anyone who subscribes to it.

Endpoints:

- `GET /actor`
- `POST /inbox`
- `GET /.well-known/webfinger`

Operations:

- Send a Follow activity to the inbox to subscribe
- Send an Undo of Follow activity to the inbox to unsubscribe
- Send anything else to the inbox to broadcast it

Requirements:

- All requests must be HTTP-signed with a valid actor
- Only payload that contain a linked-data signature will be re-broadcast

Setting up:

- `rake db:setup` to create database
- `rake keygen` to create actor signature key
