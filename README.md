# TellerSandbox

This is an API sandbox used for testing the Teller API.

## Starting the API

```sh
mix deps get
iex -S mix phx.server
```

You should now be able to send requests to the API. There is also a liveview dashboard available under `/dashboard`

### Making a request

The sandbox requires basic authorization in the form of a username and a blank password. The username should be a url safe string, prepended with `test_` then a 10 digit random number.

Now when calling the API be sure to provide the auth as a header like so:

```sh
curl --user test_3672394111: http://localhost:4000
```

To make the developer's life easier you can specify `test_multiple_3672394111` to receive a response with multiple accounts.

Each token will always return the same response per day. If a day passes, the old responses will still be returned, but a new one for the new day will be added.


### Tests

```sh
mix test
```
