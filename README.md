**[DEPRECATED] This repository is no longer maintained**
> While this project is fully functional, the content is no longer maintained and therefore is no longer up to date. You are still welcome to explore, learn, and use the code provided here.
>
> The original images are also no longer available at [Docker Hub](https://hub.docker.com/).

# Tools

A Docker image with some useful DevOps tools.

## Supported tags

- `0.0.1`
- `0.0.2`, `latest`

## What is included?

The docker image contains the following tools:

- AWS CLI
- Azure CLI
- Git
- Hub
- Packer
- Terraform

## Getting Started

There are a couple of things needed for the script to work.

### Prerequisites

Docker, either the Community Edition (CE) or Enterprise Edition (EE), needs to
be installed on your local computer.

#### Docker

Docker installation instructions can be found
[here](https://docs.docker.com/install/).

### Usage

Execute the desired tool

```
docker run --rm --interactive --tty fscm/tools:latest TOOL_NAME
```

List of tools ('TOOL_NAME'):
* `aws` - The AWS Command Line Interface tool.
* `az` - The Azure CLI.
* `git` - The distributed version control system.
* `hub` - A command-line tool for GitHub
* `packer` - The HashiCorp Packer tool.
* `terraform` - The HashiCorp Terraform tool.


#### Volumes

Volumes defined inside the docker image:

* `/work` - Default working directory of the docker image.

To set a working directory, containing the required files to be passed to a
tool by use the following command

```
docker run --volume LOCAL_FOLDER_PATH:/work:rw --rm --interactive --tty fscm/tools:latest TOOL_NAME
```

## Build

Build instructions can be found
[here](https://github.com/fscm/docker-tools/blob/master/README.build.md).

## Versioning

This project uses [SemVer](http://semver.org/) for versioning. For the versions
available, see the [tags on this repository](https://github.com/fscm/docker-tools/tags).

## Authors

* **Frederico Martins** - [fscm](https://github.com/fscm)

See also the list of [contributors](https://github.com/fscm/docker-tools/contributors)
who participated in this project.
