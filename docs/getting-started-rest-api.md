# ![logo-blue-back-boxed](https://github.com/ibexus-platform/ibexus-connector/assets/67227/d64936b4-372b-4719-b841-2c839936ddb8)

## Getting started with the IBEXUS Connector REST API

To get comfortable with the IBEXUS platform, please follow along whith this quick tutorial. If you have any further question, please do not hesitate to contact [developer@ibexus.io](mailto:developer@ibexus.io). If you use the docker container, you need to have the Docker container runtime available on your platform.

## Running the IBEXUS Connector REST API from a container image

IBEXUS Connector is available as a container image on Docker Hub. Use the following command to download and run the image. You will start the container image in sandbox mode and map its web interface to port 8000 on your machine. Sandbox mode allows you to try out all functionality of IBEXUS with a local sandbox. No data is leaving your machine in sandbox mode.

```shell
docker run  --name ibexus-connector --platform linux/amd64 -d -p 8000:8000 ibexus/ibexus-connector:latest
```

## Running the IBEXUS Connector REST API on the command line

On a x86_64 machine with Linux you can download the tool and execute it directly on the command line. Download and unpack IBEXUS Connector 0.2.0 with

 ```shell
 wget https://github.com/ibexus-platform/ibexus-connector/releases/download/v0.2.0/ibexus-connector-0.2.0-x86_64-linux.zip && unzip ibexus-connector-0.2.0-x86_64-linux.zip && mv ibexus-connector /usr/local/bin
 ```

Now you can start the IBEXUS Connector REST API on port 8000 with `ibexus-connector server`. To get an overview of the options available, run `ibexus-connector server --help`.

## Accessing the REST API documentation

To browse the documentation, open <http://localhost:8000/api-docs> in your browser. You will find an [OpenAPI](https://www.openapis.org/) compatible specification and documentation.

![ibexus-connector-rest-api-docs-screenshot](https://github.com/ibexus-platform/ibexus-connector/assets/67227/ce88e985-18a2-42fd-992a-cd011b6a9d1f)

## Initializing the sandbox

IBEXUS Connector has a built-in sandbox functionality, which allows you to simulate and test every feature of the IBEXUS platform within a local simulation. In sandbox mode, no data leaves your machine, you do not even need an active internet connection if you run the docker container locally. All data is stored in the docker image at `/etc/ibexus` or at `~/.ibexus/sandbox` if you run IBEXUS Connector locally. In order to use the sandbox, you just need to select the "sandbox" chain instead of one of the other available chains, as demonstrated below.

To get started using the sandbox, initialize the sandbox with a HTTP request. The JSON response contains invite codes for each supported blockchain that can be used to create an account, which we will do in the next step. Note that the sandbox, unlike the production environment, will always use the same invite codes.

```shell
curl -X POST "localhost:8000/sandbox/initialize"

{"codes":["EuMKp7STb7Kax3v9gJcMJ3WRU92d1DjjabCvF7oYTwWj","uguvMzUSJDpWgmAeafQEZzrEVXMrzDPZ8GALo6nLfDT","Auevovj8Hz2eA9bsZotN7cMjFeZwnGKFt39sCm5ZUZTd","7N1cAWLGUn7MARVwBqsXs7sbAiL2uoApKkPPhiSfhTjk","CSty5h41kV1Qj7UzM7mpsdzy6ZgQwiQ57Bm7MmoDAH91"]}
```

## Create account with invite code

Now you can create an account using one of the provided invite codes. On IBEXUS **accounts** correspond to one business or other legal entity. Accounts can have multiple **users**. Each user is assigned a role. There are the following roles:

- **Managers** administer other users
- **Creators** create processes on the IBEXUS platform
- **Executors** execute steps of processes
- **Designers** currently not used

When you create a new account, you need to supply one of the invite codes. Each code can only be used once to create an account. Create an account using the following request, including placedholder contact data.

```shell
curl -X POST "http://localhost:8000/account" -H "content-type: application/json" -d '{"invite":"EuMKp7STb7Kax3v9gJcMJ3WRU92d1DjjabCvF7oYTwWj","chain":"sandbox","contact":{"email":"example@acme.com","phone":"+41793456789"}}'

{"key":"<ACCOUNT_KEY>"}
```

The account key, symbolized in the output with `<ACCOUNT_KEY>`, will be different each time you create a new account. It is the unique primary identifier for the account. When IBEXUS Connector created the account, it also created a secret signing key for it, which was stored in the secrets storage of the container. Stored secrets are automatically loaded if required by a command.

## Create user with role manager

Now we can create the users we need to be able to create and execute a process. First we create a manager user. The manager user will sign the requests to create a user with the executor role and one with the creator role. One again, the `email` and `phone` fields can be set to placeholder values when using the sandbox.

First, create a manager user with the following command. Replace `<ACCOUNT_KEY>` with the account key of the account that you created. Note that we are just supplying the key here. The secret of the account was stored in the secrets storage and will be looked up there.

```shell
curl -X POST "http://localhost:8000/user" -H "content-type: application/json" -d '{"creator":"<ACCOUNT_KEY>","chain":"sandbox","role":"manager","contact":{"email":"example@acme.com","phone":"+41793456789"}}'

{"key":"<MANAGER_KEY>"}
```

Note the key of the manager user that is returned in the response, you need it in the next step.

## Create creator user

Creator users are authorized to create processes on the IBEXUS platform (and in the sandbox). To create a process, we first need to create a user that can send a create process message. Issue the following command, replace `<MANAGER_KEY>` with the key of the manager user from the last step.

```shell
curl -X POST "http://localhost:8000/user" -H "content-type: application/json" -d '{"creator":"MANAGER_KEY","chain":"sandbox","role":"creator","contact":{"email":"example@acme.com","phone":"+41793456789"}}'

{"key":"<CREATOR_KEY>"}
```

Note the key of the creator user that is returned in the response, you need it later.

## Create executor user

Create an executor user authorized to execute process steps. Issue the following command, replace `<MANAGER_KEY>` with the key of the manager user.

```shell
curl -X POST "http://localhost:8000/user" -H "content-type: application/json" -d '{"creator":"MANAGER_KEY","chain":"sandbox","role":"executor","contact":{"email":"example@acme.com","phone":"+41793456789"}}'

{"key":"<EXECUTOR_KEY>"}
```

Note the key of the executor user that is returned in the response, you need it later.

## Create a process

You are now ready for using the IBEXUS platform for running collaborative and asserted business processes. We will deploy a simple process into the sandbox. Both steps of the process will be assigned to our executor user. In real-life processes, the steps could be executed by users from different accounts (and therefore companies).

Our simple process is made up of three steps: in the first step, some data is shared. In the second step, this data is verified. If the verifier accepts the data, a permanent data record of the proces and the data is created automatically. This is the whole process. In JSON notation, this process looks as follows. All keys are randomly generated UUIDs of 16 bytes length, encoded in base58 format. For now, you can use the JSON as is.

The keys used are as follows:

- Roles define which users can execute specific steps of a process. Therefore, the role is referenced in the process using its key. The key used for the role is `7Kc9KAEmpXex2aihgCgCDM`
- Scopes define storage spaces for a process. Data collected during process execution is collected into defined scopes. Scopes can then be used to create PDRs (Permanent Data Records). Scopes are referenced by their keys. The scope key used in this example process is `8C2kCzsB2fJy9MiZos1mS`.
- Fields are used to store data into scopes. A field definition contains a name and a type for the data to be stored. Fields are in a process design and referenced via their keys during process execution. The field key used in the example process is `FP4VQzjM4KcwHiS8cj2Xs`.

```json
{
  "roles": [
      {
          "key": "7Kc9KAEmpXex2aihgCgCDM",
          "name": "Execute all steps"
      }
  ],
  "scopes": [
      {
          "key": "8C2kCzsB2fJy9MiZos1mS",
          "name": "Public Data",
          "type": {"public_data": {}}
      }
  ],
  "steps": {
      "type": {
          "share": {
              "callers": [
                  "7Kc9KAEmpXex2aihgCgCDM"
              ],
              "fields": [
                  {
                      "key": "FP4VQzjM4KcwHiS8cj2Xs",
                      "name": "Data field",
                      "scope": "8C2kCzsB2fJy9MiZos1mS",
                      "type": "String"
                  }
              ],
              "timeout": 178,
              "share": {
                  "type": {
                      "verify": {
                          "callers": ["7Kc9KAEmpXex2aihgCgCDM"],
                          "attempts": 1,
                          "timeout": 122,
                          "reject": {"type": {"end": {}}},
                          "accept": {
                              "type": {
                                  "pdr": {
                                      "scope": "8C2kCzsB2fJy9MiZos1mS",
                                      "next": {"type": {"end": {}}}
                                  }
                              }
                          }
                      }
                  }
              },
              "cancel": {"type": {"end": {}}}
          }
      }
  }
}
```

Additionally you need to define which user will be assigned to each role defined in the design. This assignment is passed in as the `mandates` parameter, also in JSON format. In JSON, the list of mandates we will use looks like the following. There is only one role in the the process, and we assign our executor user to this role.

```json
[
  {
    "role":"7Kc9KAEmpXex2aihgCgCDM",
    "user":"<EXECUTOR_KEY>"
  }
]
```

We just need a name for the process and now we can create it in the sandbox. Issue the following request to create a process. Replace `<EXECUTOR_KEY>` in the mandates JSON with the key of your executor user. Also replace <CREATOR_KEY> with the key of your creator user. The whole curl command is one line, take care that you paste it into your shell as one line.

```shell
curl -X POST "http://localhost:8000/process" -H "content-type: application/json" -d '{"user":"<CREATOR_KEY>","chain":"sandbox","name":"Example Process","mandates":[{"role":"7Kc9KAEmpXex2aihgCgCDM","user":"<EXECUTOR_KEY>"}],"design":{"roles":[{"key":"7Kc9KAEmpXex2aihgCgCDM","name":"Execute all steps"}],"scopes":[{"key":"8C2kCzsB2fJy9MiZos1mS","name":"Public Data","type":{"public_data":{}}}],"steps":{"type":{"share":{"callers":["7Kc9KAEmpXex2aihgCgCDM"],"fields":[{"key":"FP4VQzjM4KcwHiS8cj2Xs","name":"Data field","scope":"8C2kCzsB2fJy9MiZos1mS","type":"String"}],"timeout":178,"share":{"type":{"verify":{"callers":["7Kc9KAEmpXex2aihgCgCDM"],"attempts":1,"timeout":122,"reject":{"type":{"end":{}}},"accept":{"type":{"pdr":{"scope":"8C2kCzsB2fJy9MiZos1mS","next":{"type":{"end":{}}}}}}}}},"cancel":{"type":{"end":{}}}}}}}}'

{"key":"<PROCESS_KEY>"}
```

Note the key of the process that is returned in the response, you need it later.

## Get process and process history

Use these commands to retrieve the process definition itself, the current state of the process, as well as the list of already processed actions. Actual key values are replace with the <KEY_NAMES> in the requests and in the responses.

```shell
curl -X GET "http://localhost:8000/process/<PROCESS_KEY>?chain=sandbox"
curl -X GET "http://localhost:8000/process/<PROCESS_KEY>/history?chain=sandbox"
```

## Get the process state

You can also use `ibexus-connector` to view the current process state on chain. You will now find the key of the first step to execute by viewing the process state.

```shell
curl -X GET "http://localhost:8000/process/<PROCESS_KEY>/state?chain=sandbox"
```

Executing this command will display the state of the process on chain in JSON format. The output will be similar to the JSON below. The second property with the name `position` gives you the key of the current step of the process that is waiting to be executed.

```json
{
  "key": "ReyxSjWJPa1uTu8BgaVuR3",
  "position": "FztXPT9D3unSTQKyWmmBmV",
  "called_by": [],
  "scope_states": [...],
  "step_states": [...]
}
```

## Execute share step of process

Now that the process has been created, you can execute the first step using the executor user. To execute a process, you have to supply an action in JSON format. The action for the first step of our process is as follows. Note that you have to use the same keys as in the process. If you did not change any keys in the JSON of the process you are fine. The action target the first step of the process, which is a share step. It writes the string `"Test String"` as data into the only scope of the process, which is a public data scope.

```json
{
  "share": {
    "type": {
      "share": {
        "scope_items": [
          {
            "scope": "8C2kCzsB2fJy9MiZos1mS",
            "type": {
              "public_data": {
                "data_items": [
                  {
                    "field": "FP4VQzjM4KcwHiS8cj2Xs",
                    "type": { "string_value": "Test String" }
                  }
                ]
              }
            }
          }
        ]
      }
    }
  }
}
```

Execute the following request to let your executor user execute the first step of the process. Replace `<EXECUTOR_KEY>` with the key of your executor user and `<PROCESS_KEY>` with the key of the process you created.  The `<STEP_KEY>` is is the key you retrieved from the process state from the field `position`. Note that execution requests are asynchrounous. To check successful execution, you need to view the process state or process history.

```shell
curl -X POST "http://localhost:8000/process/<PROCESS_KEY>/execute" -H "content-type: application/json" -d '{"user":"<EXECUTOR_KEY>","chain":"sandbox","step":"<STEP_KEY>","action":{"share":{"type":{"share":{"scope_items":[{"scope":"8C2kCzsB2fJy9MiZos1mS","type":{"public_data":{"data_items":[{"field":"FP4VQzjM4KcwHiS8cj2Xs","type":{"string_value":"Some Value"}}]}}}]}}}}}'
```

## Execute verify step of process

The next step of the process is a verify step. The caller of this step accepts or rejects the data of the preceding share step. Therefore, the action can be of type accept or reject. See the JSON for an accept step below. The action will accept the data and give a reason of `"All good"`.

```json
{
  "verify": {
    "type": {
      "accept": {
        "reason": "All good"
      }
    }
  }
}
```

Execute the following command to get the new position of the process that is ready for execution. Get the key of the current step from the returned JSON, in the field `position`.

```shell
curl -X GET "http://localhost:8000/process/<PROCESS_KEY>/state?chain=sandbox"
```

Execute the following command to execute the next and last step in the process. Replace `<EXECUTOR_KEY>` with the key of your executor user and `<PROCESS_KEY>` with the key of the process you created. The `<STEP_KEY>` is the new value of the field `position` in the JSON data returned from the command you just executed.

```shell
curl -X POST "http://localhost:8000/process/<PROCESS_KEY>/execute" -H "content-type: application/json" -d '{"user":"<EXECUTOR_KEY>","chain":"sandbox","step":"<STEP_KEY>>","action":{"verify":{"type":{"accept":{"reason":"All good"}}}}}'
```

## Permanent data record creation

After the data has been verified, a permanent data record (PDR) is automatically created from the data. A PDR is stored on a permanent, decentralized storage blockchain (we are currently using Arweave and will be adding more options in the future), accessible for at least the next 200 years. You can use the `ibexus-connector` tool to view the data record that was created:

```shell
curl -X GET "http://localhost:8000/pdr?chain=sandbox&process_key=<PROCESS_KEY>"
```

This command will list all PDR data that has been created by your process with the key `<PROCESS_KEY>`.

## Wrapping up

Congratulations, you have run your first collaborative and asserted business process on IBEXUS! You can now create trusted, transparent and fully auditable business processes using the IBEXUS platform and document the outcomes using permanent data records. To clean up, stop and remove the container

```shell
docker stop ibexus-connector
docker remove ibexus-connector
```

Where to go from here: Design your own process or try out the comand line tool. To start the rest server, execute the command `ibexus-connector server --help` for detailed instructions. Connect with us at [developer@ibexus.io](mailto:developer@ibexus.io) to see how your business can maximize efficiency using IBEXUS.
