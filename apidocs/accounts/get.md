# Show All Accounts

Show all Accounts the server currently has

**URL** : `/accounts/`

**Method** : `GET`

**Data constraints** : `{}`

## Success Responses

**Condition** : User can not see any Accounts.

**Code** : `200 OK`

**Content** : 

```json
{
    "accounts": []
}
```

### OR

**Condition** : User can see one or more Accounts.

**Code** : `200 OK`

**Content** : In this example, the User can see three Accounts with their UUID

```json
{
    "accounts": [
        "bd110896-dd66-477c-b370-012af90ed994",
        "8fb951d1-fe29-487e-b23c-e21d977dccd6"
    ]
}
```