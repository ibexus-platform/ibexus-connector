![logo-blue-back-boxed](https://github.com/ibexus-platform/ibexus-connector/assets/67227/d64936b4-372b-4719-b841-2c839936ddb8)

# IBEXUS Connector

Welcome to IBEXUS! This IBEXUS Connector is used access the IBEXUS platform. It provides the following features:

- **Accounts and users** create your IBEXUS account and users for collaborating on the IBEXUS platform
- **Process creation and execution** create processes and run them on IBEXUS
- **Signing and encryption** all the necessary cryptography is manages by the IBEXUS Connector. You do not need to implement anything manually
- **Integration with secret managers** so far, AWS Secrets Manager and local file storage are implemented
- **Integrated sandbox** for testing and development, use the integrated sandbox environment to simulate all interactions locally

You can use IBEXUS Connector in one of two ways:

- Command line tool: use IBEXUS Connector as a command line utility for testing and development. Secrets are stored on your filesystem, do not use for production.
- REST API: run the IBEXUS Connector as a docker container image in your environment and use it to connect to the IBEXUS platform.

## Download and installation

Follow these instructions to download and install IBEXUS connector in your environment. Releases are available in two kinds: an executable file or a container image. Both kinds support command line tool and REST API usage of IBEXUS Connector.

### Executable file

Download the executable binary at <https://github.com/ibexus-platform/ibexus-connector/releases>. At the moment, only Unix 64bit is supported. Unpack the `.zip` file and move the contained executable to a location of your choice, preferrably `/usr/local/bin` or some other location in your shell's `PATH`. Run the binary from your terminal with `ibexus-connector`. The binary supports both the command line tool and the REST API modes of IBEXUS Connector. The executable has extensive documentation available. Get started by executing `ibexus-connector --help` in your terminal.

### Container image

Access the image at Docker Hub: <https://hub.docker.com/r/ibexus/ibexus-connector>.

#### Environment variables

In order for the image to start up correctly, you have to set at least one environment variable.

- `IBEXUS_API_KEYS` **must** be set to a list of comma-separated keys that should allow access to the API.
- `IBEXUS_SECRETS_STORAGE` should be set to the secrets storage type that is being used. Default is a non-secure file-based storage (`file`). Set the environment variable to `aws-secrets-manager` to enable AWS secrets manager support.
- `IBEXUS_PORT` can be used to set a non-default port. The default port is `80`.
- `IBEXUS_SECRETS_PATH` can be used to set the directory path to the secrets storage file. The default location is `~/.ibexus`.
- `IBEXUS_SANDBOX` enables the built-in sandbox if it is present (the value is ignored). If the sandbox is enabled, all requests go to a sandbox implementation of the IBEXUS platform.
- `IBEXUS_SANDBOX_PATH` can be used to set the directory path to the sandbox storage files. The default location is `~/.ibexus`.
- `IBEXUS_GRPC_URL` can be used to change the URL that IBEXUS Connector uses to connect to the IBEXIS platform

### REST API documentation

Refer to the interactive documentation in order to find out more about all possible REST requests by navigating to `/api-docs` at the address of the container. Per default the exposed port is `80`.

### Command line tool usage

Connect to your container via a shell to use ibexus-connector on the command line. The executable is located at `/usr/local/bin/ibexus-connector`.

## Documentation

[Getting started with the IBEXUS Connector command line tool](https://github.com/ibexus-platform/ibexus-connector/blob/main/docs/getting-started-command-line-tool.md)
