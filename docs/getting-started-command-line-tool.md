# ![logo-blue-back-boxed](https://github.com/ibexus-platform/ibexus-connector/assets/67227/d64936b4-372b-4719-b841-2c839936ddb8)

## Getting started with the IBEXUS Connector command line tool

To get comfortable with the IBEXUS platform, please follow along whith this quick tutorial. If you have any further question, please do not hesitate contacting [developer@ibexus.io](mailto:developer@ibexus.io). In order to complete this tutorial, you need to have access to a linux terminal or a docker installation. Internet access is not required for this simple tutorial, as we will be using the sandbox environment built into IBEXUS Connector.

### Using the command line tool on Intel Linux

On a x86 machine with Linux you can download the tool and execute it directly on the command line. Download and unpack IBEXUS Connector 0.2.0 with

 ```shell
 wget https://github.com/ibexus-platform/ibexus-connector/releases/download/v0.2.0/ibexus-connector-0.2.0-x86_64-linux.zip && unzip ibexus-connector-0.2.0-x86_64-linux.zip && mv ibexus-connector /usr/local/bin
 ```

Now you can run IBEXUS Connector with `ibexus-connector`

## Running the command line tool in a docker container

If you are not on a Linux system you can use Docker to run IBEXUS Connector in a container image. Install Docker and start a terminal session in an Debian Docker container with the following command:

```shell
docker run -it --platform linux/amd64 debian:latest /bin/bash
```

In the new terminal session, run `apt update` and then `apt install -y zip wget` to install the necessary tools to download and unpack IBEXUS Connector. Finally, download and unpack IBEXUS Connector.

```shell
wget https://github.com/ibexus-platform/ibexus-connector/releases/download/v0.2.0/ibexus-connector-0.2.0-x86_64-linux.zip && unzip ibexus-connector-0.2.0-x86_64-linux.zip && mv ibexus-connector /usr/local/bin
```

Now you can run IBEXUS Connector with `ibexus-connector` in your Docker container.

## Displaying available commands

To get a list of available command, execute `ibexus-connector`. This will show you a list of available commands and options, as shown below. Use `ibexus-connector --help` to get a more detailed response. There is more detailed help available for every command. To display detailed help for a specific command, use e.g. `ibexus-connector user create --help`.

```console
IBEXUS Connector

Support: developer@ibexus.io
Version: 0.2.0

Usage:

ibexus-connector [OPTIONS] <COMMAND>

Commands:
  docs  Start a web server just for looking at the REST API documentation
  server    Start as a REST API server
  process   Manage processes
  user      Manage users
  account   Manage accounts
  invite    Manage invites
  admin     Manage admins
  sandbox   manage the built-in sandbox environment
  help      Print this message or the help of the given subcommand(s)

Options:
                          Enable sandbox [env: IBEXUS_SANDBOX=]
    -path <SANDBOX_PATH>  Sandbox storage path [env: IBEXUS_SANDBOX_PATH=]
      --grpc-url <GRPC_URL>          gRPC domain [env: IBEXUS_GRPC_URL=] [default: https://grpc.ibexus.io/view]
      --json-output                  JSON Output [env: IBEXUS_JSON_OUTPUT=]
  -h, --help                         Print help (see more with '--help')
  -V, --version                      Print version
```

## Initializing the sandbox

IBEXUS Connector has a built-in sandbox functionality, which allows you to simulate and test every feature of the IBEXUS platform within a local simulation. In sandbox mode, no data leaves your machine, you do not even need an active internet connection. All data is stored on your local disk. The default storage path is `~/.ibexus`. In order to use the sandbox, you just need to select the "sandbox" chain instead of one of the other available chains, as demonstrated below.

To get started using the sandbox, initialize the sandbox with the command `ibexus-connector sandbox initialize`, which will produce the following output. Note that the sandbox, unlike the production environment, will always use the same invite codes.

```console
The sandbox was reset to an empty state. The following invite codes are now available:

    EuMKp7STb7Kax3v9gJcMJ3WRU92d1DjjabCvF7oYTwWj
    uguvMzUSJDpWgmAeafQEZzrEVXMrzDPZ8GALo6nLfDT
    Auevovj8Hz2eA9bsZotN7cMjFeZwnGKFt39sCm5ZUZTd
    7N1cAWLGUn7MARVwBqsXs7sbAiL2uoApKkPPhiSfhTjk
    CSty5h41kV1Qj7UzM7mpsdzy6ZgQwiQ57Bm7MmoDAH91
```

## Create account with invite code

Now you can create an account using one of the provided invite codes. On IBEXUS **accounts** correspond to one business or other legal entity. Accounts can have multiple **users**. Each user is assigned a role. There are the following roles:

- **Managers** administer other users
- **Creators** create processes on the IBEXUS platform
- **Executors** execute steps of processes
- **Designers** currently not used

When you create a new account, you need to supply one of the invite codes. Each code can only be used once to create an account. Run the command `ibexus-connector account create --help` to display help on the required parameters. For the sandbox the fields parameters `email` and `phone` can be assigned placeholder values. Create an account using the following command.

```shell
ibexus-connector account create --chain sandbox --email example@example.com --phone 123123123 --invite-code EuMKp7STb7Kax3v9gJcMJ3WRU92d1DjjabCvF7oYTwWj
```

This command will produce something similar to the following output:

```shell
Key of new account: <ACCOUNT_KEY>
The signing key of the new account is available in the ibexus-connector secrets file (default location is ~/.ibexus/secrets.json).
```

The account key, symbolized in the output with `<ACCOUNT_KEY>`, will be different each time you create a new account. It is the unique primary identifier for the account. When IBEXUS Connector created the account, it also created a secret signing key for it, which was stored in the secrets file.

To display the contents of the secrets file issue the following command in your terminal: `cat ~/.ibexus/secrets.json`. The file contains a JSON map, mapping keys of accounts and users to their respective signing keys. Secrets stored in the file are automatically loaded if required by a command.

## Create user with role manager

Now we can create the users we need to be able to create and execute a process. First we create a manager user. The manager user will sign the requests to create a user with the executor role and one with the creator role. One again, the `email` and `phone` fields can be set to placeholder values when using the sandbox. First, create a manager user with the following command. Replace `<ACCOUNT_KEY>` with the account key of the account that you created.

Note that we are just supplying the key here. The secret of the account was stored in the `secrets.json` file and will be looked up there. You can also supply a secret as an environment variable, using the key as the name of the variable, prefixed with "IBEXUS_", and the signing key as the value.

```shell
ibexus-connector user create --chain sandbox --role manager --email example@example.com --phone 123123123 --account-key <ACCOUNT_KEY>
```

This command will produce something similar to the following output. Note the key of the manager user, you need it in the next step.

```shell
Key of new user: <MANAGER_KEY>
The signing key of the new user is available in the ibexus-connector secrets file (default location is ~/.ibexus/secrets.json).
```

## Create creator user

Creator users are authorized to create processes on the IBEXUS platform (and in the sandbox). To create a process, we first need to create a user that can send a create process message. Issue the following command, replace `<MANAGER_KEY>` with the key of the manager user from the last step.

```shell
ibexus-connector user create --chain sandbox --role creator --email example@example.com --phone 123123123 --manager-key <MANAGER_KEY>
```

This command will produce something similar to the following output. Note the key of the creator user, you need it later.

```shell
Key of new account: <CREATOR_KEY>
The signing key of the new user is available in the ibexus-connector secrets file (default location is ~/.ibexus/secrets.json).
```

## Create executor user

Create an executor user authorized to execute process steps. Issue the following command, replace `<MANAGER_KEY>` with the key of the manager user.

```shell
ibexus-connector user create --chain sandbox --role executor --email example@example.com --phone 123123123 --manager-key <MANAGER_KEY>
```

This command will produce something similar to the following output. Note the key of the creator user, you need it later.

```shell
Key of new account: <EXECUTOR_KEY>
The signing key of the new user is available in the ibexus-connector secrets file (default location is ~/.ibexus/secrets.json).
```

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
      "type": {
        "public_data": {
          "fields": [
            {
              "key": "FP4VQzjM4KcwHiS8cj2Xs",
              "name": "Data field",
              "type": "String"
            }
          ]
        }
      }
    }
  ],
  "steps": {
    "type": {
      "share": {
        "callers": [
          "7Kc9KAEmpXex2aihgCgCDM"
        ],
        "fields": [
          "FP4VQzjM4KcwHiS8cj2Xs"
        ],
        "timeout": 178,
        "share": {
          "type": {
            "verify": {
              "callers": [
                "7Kc9KAEmpXex2aihgCgCDM"
              ],
              "attempts": 1,
              "timeout": 122,
              "reject": {
                "type": {
                  "end": {}
                }
              },
              "accept": {
                "type": {
                  "pdr": {
                    "scope": "8C2kCzsB2fJy9MiZos1mS",
                    "next": {
                      "type": {
                        "end": {}
                      }
                    }
                  }
                }
              }
            }
          }
        },
        "cancel": {
          "type": {
            "end": {}
          }
        }
      }
    }
  }
}```

Additionally you need to define which user will be assigned to each role defined in the design. This assignment is passed in as the `mandates` parameter, also in JSON format. In JSON, the list of mandates we will use looks like the following. There is only one role in the the process, and we assign our executor user to this role.

```json
[
  {
    "role":"7Kc9KAEmpXex2aihgCgCDM",
    "user":"<EXECUTOR_KEY>"
  }
]
```

We just need a name for the process and now we can create it in the sandbox. Issue the following command to create a process. Replace `<EXECUTOR_KEY>` in the mandates JSON with the key of your executor user. Also replace `<CREATOR_KEY>` with the key of your creator user. The whole command is one line, take care that you paste it into your shell as one line.

```shell
ibexus-connector process create --chain sandbox --creator-key <CREATOR_KEY> --design '{"roles":[{"key":"7Kc9KAEmpXex2aihgCgCDM","name":"Execute all steps"}],"scopes":[{"key":"8C2kCzsB2fJy9MiZos1mS","name":"Public Data","type":{"public_data":{}}}],"steps":{"type":{"share":{"callers":["7Kc9KAEmpXex2aihgCgCDM"],"fields":[{"key":"FP4VQzjM4KcwHiS8cj2Xs","name":"Data field","scope":"8C2kCzsB2fJy9MiZos1mS","type":"String"}],"timeout":178,"share":{"type":{"verify":{"callers":["7Kc9KAEmpXex2aihgCgCDM"],"attempts":1,"timeout":122,"reject":{"type":{"end":{}}},"accept":{"type":{"pdr":{"scope":"8C2kCzsB2fJy9MiZos1mS","next":{"type":{"end":{}}}}}}}}},"cancel":{"type":{"end":{}}}}}}}' --mandates '[{"role":"7Kc9KAEmpXex2aihgCgCDM","user":"<EXECUTOR_KEY>"}]' --name "Example Process"
```

The execution of this command should result in an output similar to the one below. Note the key of the created process, you need it later.

```shell
Key of new process: DjNVxDGLbnEbnFyzpKDRWy
```

## Get the process state

You can use `ibexus-connector` to view the current process state on chain. You will now find the key of the first step to execute by viewing the process state.

```shell
ibexus-connector process view-state --chain sandbox --process-key <PROCESS_KEY>
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

Now you can execute the first step of the process using the executor user. To execute a process, you have to supply an action in JSON format. The action for the first step of our process is as follows. Note that you have to use the same keys as in the process. If you did not change any keys in the JSON of the process you are fine. The action target the first step of the process, which is a share step. It writes the string `"Test String"` as data into the only scope of the process, which is a public data scope.

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

Execute the following command to let your executor user execute the first step of the process. Replace `<EXECUTOR_KEY>` with the key of your executor user and `<PROCESS_KEY>` with the key of the process you created. The `<STEP_KEY>` is is the key you retrieved from the process state from the field `position`.

```shell
ibexus-connector process execute --chain sandbox --executor-key <EXECUTOR_KEY> --process-key <PROCESS_KEY> --step-key <STEP_KEY> --action '{"share":{"type":{"share":{"scope_items":[{"scope":"8C2kCzsB2fJy9MiZos1mS","type":{"public_data":{"data_items":[{"field":"FP4VQzjM4KcwHiS8cj2Xs","type":{"string_value":"Test String"}}]}}}]}}}}'
```

You will receive a notice that the execution request has been sent:

```shell
Execution request sent. You can check process state with `ibexus-connector process view_state` and `ibexus-connector process view_history`
```

Use the `view_state` command as before to retrieve the new position of the process. The value of the `position` field will be the new `STEP_KEY` to use for the next execution call to the process.

```shell
ibexus-connector process view-state --chain sandbox --process-key <PROCESS_KEY>
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

Execute the following command to execute the next and last step in the process. Replace `<EXECUTOR_KEY>` with the key of your executor user and `<PROCESS_KEY>` with the key of the process you created. The `<STEP_KEY>` is the value of the position field that you retrieved from the process state after executing the first step.

```shell
ibexus-connector process execute --chain sandbox --executor-key <EXECUTOR_KEY> --process-key <PROCESS_KEY> --step-key <STEP_KEY> --action '{"verify":{"type":{"accept":{"reason":"All good"}}}}'
```

You will receive a notice that the execution request has been sent:

```shell
Execution request sent. You can check process state with `ibexus-connector process view_state` and `ibexus-connector process view_history`
```

The process is not completed. If you would view the process state again, you would see that the position is now `null`.

## Permanent data record creation

After the data has been verified, a permanent data record (PDR) is automatically created from the data. A PDR is stored on a permanent, decentralized storage blockchain (we are currently using Arweave and will be adding more options in the future), accessible for at least the next 200 years. You can use the `ibexus-connector` tool to view the data record that was created:

```shell
ibexus-connector pdr list --chain sandbox --process-key <PROCESS_KEY>
```

This command will list all PDR data that has been created by your process with the key `<PROCESS_KEY>`.

## Wrapping up

Congratulations, you have run your first collaborative and asserted business process on IBEXUS! You can now create trusted, transparent and fully auditable business processes using the IBEXUS platform and document the outcomes using permanent data records.

Where to go from here: Design your own process or try out the REST API. To start the rest server, execute the command `ibexus-connector server --help` for detailed instructions. Connect with us at [developer@ibexus.io](mailto:developer@ibexus.io) to see how your business can maximize efficiency using IBEXUS.
