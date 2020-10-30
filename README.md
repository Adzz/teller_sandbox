# TellerSandbox

This is an API sandbox used for testing the Teller API.

## Starting the API

```sh
mix deps get
iex -S mix phx.server
```

You should now be able to send requests to the API. There is also a liveview dashboard available under `/dashboard`

### Making a request

It requires basic authorization in the form of a username and a blank password. The username should be a url safe string, prepended with `test_`.

Now when calling the API be sure to provide the auth as a header like so:

```sh
curl --user test_my_awesome_token: http://localhost:4000
```

### Tests

```sh
mix test
```
