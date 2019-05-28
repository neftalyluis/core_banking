# CoreBanking
A server for handling BankAccounts

## API Documentation
- There is no library for making API docs guided by tests using just Plug (e.g. bureaucrat with Phoenix) so I made them on markdown files
- [API Documentation](apidocs/README.md)

## Design
I've chosen Elixir in this code challenge because is easy to make highly concurrent apps without using complex patterns (like in Java with Threads)

This app uses some Elixir/OTP abstractions for specific patterns like:
- A GenServer for handling the Accounts, as this behavior is based on the Actor concurrency model
- A DynamicSupervisor for monitoring any child processes (in this case the Account GenServer) as this module can enable us to make fault-tolerant applications easily

This application is composed of:
- Plug with Cowboy as the HTTP server (I've used this because i think that Phoenix would be a overkill for this little app)
- ExUnit for testing
- Credo for static analysis in case of CI/CD pipelines

### What I liked making this challenge
- Learned a new OTP Behaviour: The DynamicSupervisor
- Learned how to make web applications on Elixir without using Phoenix 

### What I didn't liked so much about this challenge
- The requirements of this challenge were a little open but i think the reason of this is about giving a lot of freedom of choices on making it

## Installation

### For "production" usage
If you only want to test the application without the hassle of installing Erlang and Elixir you can run the app with Docker using `make docker.start` 

### For development
You need Erlang 22 and Elixir 1.8.2 installed on your system, I suggest [asdf](https://github.com/asdf-vm/asdf.git) to manage the SDK versions

After installing the SDK you can:

- Run the app with `make start`, and the app will be available on http://localhost:8080/
- Run tests, linter, and formatter like on a CI/CD pipeline with `make ci`

