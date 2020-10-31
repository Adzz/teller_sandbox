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


### Notes to reviewers

I wasn't sure how serious you were about there being no state. Like is that no gen_servers? Go the data generation we've taken it very literally and we generate the data based on a hash of the token. Meaning the same token is guaranteed to return the same data. However, it is not guaranteed that each token returns unique data.


We can still seed data then use a hashing function to select it. That means we can pre-compute possible values and we can
