# Create User's Account

Creates an Account, you can indicate .

**URL** : `/accounts/`

**Method** : `POST`

**Data example**

You can send the request with an empty JSON and it would create it with a balance on "0"

```json
{}
```

### OR

Indicate a balance on cents

```json
{
    "balance": 12341234
}
```

## Success Response

**Code** : `201 CREATED`

**Content example**

```json
{
    "account": {
        "uuid": "01855cc9-a2d4-420f-b061-b111db9c1f66"
    }
}
```