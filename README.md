# Tools

[![Docker Pulls](https://img.shields.io/docker/pulls/fscm/tools.svg?color=black&logo=docker&logoColor=white&style=flat-square)](https://hub.docker.com/r/fscm/tools)
[![Docker Stars](https://img.shields.io/docker/stars/fscm/tools.svg?color=black&logo=docker&logoColor=white&style=flat-square)](https://hub.docker.com/r/fscm/tools)
[![Docker Build Status](https://img.shields.io/docker/cloud/build/fscm/tools.svg?color=black&logo=docker&logoColor=white&style=flat-square)](https://hub.docker.com/r/fscm/tools)

A Docker image with some useful DevOps tools.

## Supported tags

- `0.0.1`, `latest`

## What is included?

The docker image contains the following tools:

- AWS CLI
- Azure CLI
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
[here](https://github.com/fscm/docker-tools/README.build.md).

## Versioning

This project uses [SemVer](http://semver.org/) for versioning. For the versions
available, see the [tags on this repository](https://github.com/fscm/docker-tools/tags).

## Authors

* **Frederico Martins** - [fscm](https://github.com/fscm)

See also the list of [contributors](https://github.com/fscm/docker-tools/contributors)
who participated in this project.
