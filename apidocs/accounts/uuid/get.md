# Show Single Account

Show a single Account with the current balance

**URL** : `/accounts/:uuid/`

**URL Parameters** : `uuid=[string]` where `uuid` is the ID of the Account on the
server.

**Method** : `GET`

**Data**: `{}`

## Success Response

**Condition** : If Account exists

**Code** : `200 OK`

**Content example**

```json
{
    "account": {
        "balance": 0,
        "uuid": "956af564-3c0f-49d7-97f7-e60741d5d7bd"
    }
}
```

## Error Responses

**Condition** : If Account does not exist with `id` of provided `uuid` parameter.

**Code** : `404 NOT FOUND`

**Content** : `{}`

