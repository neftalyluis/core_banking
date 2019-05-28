# Updates the balance of an Account

Makes a deposit/withdrawal on a given account

**URL** : `/api/accounts/:uuid/`

**Method** : `PUT`

**URL Parameters** : `uuid=[string]` where `uuid` is the ID of the Account on the
server.

**Data**

Operation could be `deposit` or `withdrawal`

Amount should be given on cents

```json
{
    "operation": "deposit",
    "amount": 1234
}
```

## Success Responses

**Condition** : The balance is updated

**Code** : `200 OK`

**Content example** : For the example above, when we deposit 1234 cents to the account `ac068f6b-194a-4df8-a50d-ad0c2be67309`

```json
{
    "account": {
        "balance": 1234,
        "uuid": "ac068f6b-194a-4df8-a50d-ad0c2be67309"
    }
}
```

## Error Responses

**Condition** : Account does not exist

**Code** : `404 NOT FOUND`

**Content** : `{}`

### Or

**Condition** : Didn't indicated amount or operation type, or a invalid amount

**Code** : `400 BAD REQUEST`

**Content** : `{}`

### Or

**Condition** : The account doesn't have sufficient funds for this operation

**Code** : `409 CONFLICT`

**Content** : `{}`
