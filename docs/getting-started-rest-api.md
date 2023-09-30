docker run -it -p 8089:80 -e IBEXUS_SANDBOX=true -v dockervolume:/etc/ibexus ibexus/ibexus-connector:0.1.0

# ![logo-blue-back-boxed](https://github.com/ibexus-platform/ibexus-connector/assets/67227/d64936b4-372b-4719-b841-2c839936ddb8)

## Getting started with the IBEXUS Connector command line tool

To get comfortable with the IBEXUS platform, please follow along whith this quick tutorial. If you have any further question, please do not hesitate to contact [developer@ibexus.io](mailto:developer@ibexus.io). In order to complete this tutorial, you need to have the Docker container runtime available on your platform.

## Running the IBEXUS Connector image as a container

IBEXUS Connector is available as a container image on Docker Hub. Use the following command to download and run the image. You will start the container image in sandbox mode and map its web interface to port 8089 on your machine. Sandbox mode allows you to try out all functionality of IBEXUS with a local sandbox. No data is leaving your machine in sandbox mode.

```console
docker run -it -p 8089:80 -e IBEXUS_SANDBOX=true ibexus/ibexus-connector:latest
```

## Accessing the REST API documentation

To browse the documentation, open <http://localhost:8089/api-docs> in your browser. You will find an [OpenAPI](https://www.openapis.org/) compatible specification and documentation.



## Initializing the sandbox

IBEXUS Connector has a built-in sandbox functionality, which allows you to simulate and test every feature of the IBEXUS platform within a local simulation. In sandbox mode, no data leaves your machine, you do not even need an active internet connection. All data is stored on your local disk. The default storage path is `~/.ibexus`. To get started using the sandbox, initialize the sandbox with the command `ibexus-connector sandbox initialize`, which will produce the following output. Note that the sandbox will always use the same invite codes, which makes automation easier.

```console
The sandbox was reset to an empty state. The following invite codes for the different chains are now available:

Chain: Near
    EuMKp7STb7Kax3v9gJcMJ3WRU92d1DjjabCvF7oYTwWj
    uguvMzUSJDpWgmAeafQEZzrEVXMrzDPZ8GALo6nLfDT
    Auevovj8Hz2eA9bsZotN7cMjFeZwnGKFt39sCm5ZUZTd
    7N1cAWLGUn7MARVwBqsXs7sbAiL2uoApKkPPhiSfhTjk
    CSty5h41kV1Qj7UzM7mpsdzy6ZgQwiQ57Bm7MmoDAH91

Chain: Concordium
    CnjVvp4v9zCNwXW6FgUQAczA5GfjVZJCHY3WbEXaJwFS
    6Fxop3fgLyqBc7YtBxgUaFnZC3KYPvCELtSoR1mKu6yg
    Gd1MTrkLyMAtQX8TZ2oDWnNW68doM573v1GNT2RBcbFS
    CsffEHk49PVs1j6SuTsH6JgHZTuiuZE4GNosNWSodfo2
    DVXeFL5ngkYyfhrrKGojydk1VuDDPeJuJ3XoMw5drUh8
```

## Create account with invite code

Now you can create an account using one of the provided invite codes. On IBEXUS **accounts** correspond to one business or other legal entity. Accounts can have multiple **users**. Each user is assigned a role. There are the following roles:

- **Managers** administer other users
- **Creators** create processes on the IBEXUS platform
- **Executors** execute steps of processes
- **Designers** currently not used

When you create a new account, you need to supply one of the invite codes. Each code can only be used once to create an account. Run the command `ibexus-connector account create --help` to display help on the required parameters. For the sandbox the fields parameters `email` and `phone` can be assigned placeholder values. Create an account using the following command.

```console
ibexus-connector account create --sandbox --chain near --email example@example.com --phone 123123123 --invite-code EuMKp7STb7Kax3v9gJcMJ3WRU92d1DjjabCvF7oYTwWj
```

This command will produce something similar to the following output:

```console
Key of new account: <ACCOUNT_KEY>
The signing key of the new account is available in the ibexus-connector secrets file (default location is ~/.ibexus/secrets.json).
```

The account key, symbolized in the output with `<ACCOUNT_KEY>`, will be different each time you create a new account. It is the unique primary identifier for the account. When IBEXUS Connector created the account, it also created a secret signing key for it, which was stored in the secrets file. To display the contents of the secrets file issue the following command in your terminal: `cat ~/.ibexus/secrets.json`. The file contains a JSON map, mapping keys of accounts and users to their respective signing keys. Secrets stored in the file are automatically loaded if required by a command.

## Create user with role manager

Now we can create the users we need to be able to create and execute a process. First we create a manager user. The manager user will sign the requests to create a user with the executor role and one with the creator role. One again, the `email` and `phone` fields can be set to placeholder values when using the sandbox. First, create a manager user with the following command. Replace `<ACCOUNT_KEY>` with the account key of the account that you created. Note that we are just supplying the key here. The secret of the account was stored in the `secrets.json` file and will be looked up there. You can also supply a secret as an environment variable, using the key as the name of the variable, prefixed with "IBEXUS_", and the signing key as the value.

```console
ibexus-connector user create --sandbox --chain near --role manager --email example@example.com --phone 123123123 --account-key <ACCOUNT_KEY>
```

This command will produce something similar to the following output. Note the key of the manager user, you need it in the next step.

```console
Key of new user: <MANAGER_KEY>
The signing key of the new user is available in the ibexus-connector secrets file (default location is ~/.ibexus/secrets.json).
```

## Create creator user

Creator users are authorized to create processes on the IBEXUS platform (and in the sandbox). To create a process, we first need to create a user that can send a create process message. Issue the following command, replace `<MANAGER_KEY>` with the key of the manager user from the last step.

```console
ibexus-connector user create --sandbox --chain near --role creator --email example@example.com --phone 123123123 --manager-key <MANAGER_KEY>
```

This command will produce something similar to the following output. Note the key of the creator user, you need it later.

```console
Key of new account: <CREATOR_KEY>
The signing key of the new user is available in the ibexus-connector secrets file (default location is ~/.ibexus/secrets.json).
```

## Create executor user

Create an executor user authorized to exectute process steps. Issue the following command, replace `<MANAGER_KEY>` with the key of the manager user.

```console
ibexus-connector user create --sandbox --chain near --role executor --email example@example.com --phone 123123123 --manager-key <MANAGER_KEY>
```

This command will produce something similar to the following output. Note the key of the creator user, you need it later.

```console
Key of new account: <EXECUTOR_KEY>
The signing key of the new user is available in the ibexus-connector secrets file (default location is ~/.ibexus/secrets.json).
```

## Create a process

You are now ready for using the IBEXUS platform for running collaborative and asserted business processes. We will deploy a simple process into the sandbox. Both steps of the process will be assigned to our executor user. In real-life processes, the steps could be executed by users from different accounts (and therefore companies). Our simple process is made up of two steps: in the first step, some data is shared. In the second step, this data is verified. This is the whole process. In JSON notation, this process looks as follows. All keys are randomly generated UUIDs of 16 bytes length, encoded in base58 format. For now, you can use the JSON as is.

```json
{
  "roles": [{ "key": "7Kc9KAEmpXex2aihgCgCDM", "name": "Execute all steps" }],
  "scopes": [
    {
      "key": "8C2kCzsB2fJy9MiZos1mS",
      "name": "Public Data",
      "type": { "public_data": {} }
    }
  ],
  "steps": {
    "key": "Na6EczbX5yvuS59hRb3JJ",
    "type": {
      "share": {
        "callers": ["7Kc9KAEmpXex2aihgCgCDM"],
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
          "key": "Vm7ypzTh7eEsaRsGET44j",
          "type": {
            "verify": {
              "callers": ["7Kc9KAEmpXex2aihgCgCDM"],
              "attempts": 1,
              "timeout": 122,
              "reject": {
                "key": "7S6TpwJwWJLRd8sSzY4Myt",
                "type": { "end": {} }
              },
              "accept": {
                "key": "5MWqXhHd3uUnZnSTHF9eeP",
                "type": { "end": {} }
              }
            }
          }
        },
        "cancel": { "key": "GBU5ZEqagyMzFrEF5SkCEP", "type": { "end": {} } }
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

We just need a name for the process and now we can create it in the sandbox. Issue the following command to create a process. Replace `<EXECUTOR_KEY>` in the mandates JSON with the key of your executor user. Also replace <CREATOR_KEY> with the key of your creator user. The whole command is one line, take care that you paste it into your shell as one line.

```console
ibexus-connector process create --sandbox --chain near --creator-key AiC2RYD3HFKuqEHfJpVYN2 --design '{"roles":[{"key":"7Kc9KAEmpXex2aihgCgCDM","name":"Execute all steps"}],"scopes":[{"key":"8C2kCzsB2fJy9MiZos1mS","name":"Public Data","type":{"public_data":{}}}],"steps":{"key":"Na6EczbX5yvuS59hRb3JJ","type":{"share":{"callers":["7Kc9KAEmpXex2aihgCgCDM"],"fields":[{"key":"FP4VQzjM4KcwHiS8cj2Xs","name":"Data field","scope":"8C2kCzsB2fJy9MiZos1mS","type":"String"}],"timeout":178,"share":{"key":"Vm7ypzTh7eEsaRsGET44j","type":{"verify":{"callers":["7Kc9KAEmpXex2aihgCgCDM"],"attempts":1,"timeout":122,"reject":{"key":"7S6TpwJwWJLRd8sSzY4Myt","type":{"end":{}}},"accept":{"key":"5MWqXhHd3uUnZnSTHF9eeP","type":{"end":{}}}}}},"cancel":{"key":"GBU5ZEqagyMzFrEF5SkCEP","type":{"end":{}}}}}}}' --mandates '[{"role":"7Kc9KAEmpXex2aihgCgCDM","user":"5AcqTKZEk5Tj2qzg5baavm"}]' --name "Example Process"
```

The execution of this command should result in an output similar to the one below. Note the key of the created process, you need it later.

```console
Key of new process: DjNVxDGLbnEbnFyzpKDRWy
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

Execute the following command to let your executor user execute the first step of the process. Replace `<EXECUTOR_KEY>` with the key of your executor user and `<PROCESS_KEY>` with the key of the process you created. The step key is the same as in the example data from the last step and should be good as is.

```console
ibexus-connector process execute --sandbox --chain near --executor-key <EXECUTOR_KEY> --process-key <PROCESS_KEY> --step-key Na6EczbX5yvuS59hRb3JJ --action '{"share":{"type":{"share":{"scope_items":[{"scope":"8C2kCzsB2fJy9MiZos1mS","type":{"public_data":{"data_items":[{"field":"FP4VQzjM4KcwHiS8cj2Xs","type":{"string_value":"Test String"}}]}}}]}}}}'
```

You will receive a notice that the execution request has been sent:

```console
Execution request sent. You can check process state with `ibexus-connector process view_state` and `ibexus-connector process view_history`
```

You can use the commands given in the message to check on the state and the history data of your process.

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

Execute the following command to execute the next and last step in the process. Replace `<EXECUTOR_KEY>` with the key of your executor user and `<PROCESS_KEY>` with the key of the process you created. The step key is the same as in the example process above and should be good as is.

```console
ibexus-connector process execute --sandbox --chain near --executor-key 5AcqTKZEk5Tj2qzg5baavm --process-key DjNVxDGLbnEbnFyzpKDRWy --step-key Vm7ypzTh7eEsaRsGET44j --action '{"verify":{"type":{"accept":{"reason":"All good"}}}}'
```

You will receive a notice that the execution request has been sent:

```console
Execution request sent. You can check process state with `ibexus-connector process view_state` and `ibexus-connector process view_history`
```

You can use the commands given in the message to check on the state and the history data of your process.

## Wrapping up

Congratulations, you have run your first collaborative and asserted business process on IBEXUS! Where to go from here: Design your own process or try out the REST API. To start the rest server, execute the command `ibexus-connector server --help` for detailed instructions.
