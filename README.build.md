# Tools for Docker

A Docker image with some useful DevOps tools.

## Synopsis

This script will create a Docker image with the following tools installed:

- AWS CLI
- Azure CLI
- Git
- Packer
- Terraform

The Docker image resulting from this script should be the one used to run any
of those tools.

## Getting Started

There are a couple of things needed for the script to work.

### Prerequisites

Docker, either the Community Edition (CE) or Enterprise Edition (EE), needs to
be installed on your local computer.

#### Docker

Docker installation instructions can be found
[here](https://docs.docker.com/install/).

### Usage

In order to create a Docker image using this Dockerfile you need to run the
`docker` command with a few options.

```
docker build --squash --force-rm --no-cache --quiet --tag <USER>/<IMAGE>:<TAG> <PATH>
```

* `<USER>` - *[required]* The user that will own the container image (e.g.: "johndoe").
* `<IMAGE>` - *[required]* The container name (e.g.: "tools").
* `<TAG>` - *[required]* The container tag (e.g.: "latest").
* `<PATH>` - *[required]* The location of the Dockerfile folder.

A build example:

```
docker build --squash --force-rm --no-cache --quiet --tag johndoe/my_tools:latest .
```

To clean the _<none>_ image(s) left by the `--squash` option the following
command can be used:

```
docker rmi `docker images --filter "dangling=true" --quiet`
```

#### Running a Tool

Running a tool can be done by invoking the desired tool - after having build
the container image.

```
docker run --rm --interactive --tty <USER>/<IMAGE>:<TAG> <TOOL_NAME>
```

List of tools:
* `aws` - The AWS Command Line Interface tool.
* `az` - The Azure CLI.
* `git` - The distributed version control system.
* `packer` - The HashiCorp Packer tool.
* `terraform` - The HashiCorp Terraform tool.

Local folders can be mount on the image's working directory.

```
docker run --volume <LOCAL_FOLDER_PATH>:/work:rw --rm --interactive --tty <USER>/<IMAGE>:<TAG> <TOOL_NAME>
```

An example on how to run a tool:

```
docker run --volume ${PWD}:/work:rw --rm --interactive --tty <USER>/<IMAGE>:<TAG> terraform validate
```

### Add Tags to the Docker Image

Additional tags can be added to the image using the following command:

```
docker tag <image_id> <user>/<image>:<extra_tag>
```

### Push the image to Docker Hub

After adding an image to Docker, that image can be pushed to a Docker
registry... Like Docker Hub.

Make sure that you are logged in to the service.

```
docker login
```

When logged in, an image can be pushed using the following command:

```
docker push <user>/<image>:<tag>
```

Extra tags can also be pushed.

```
docker push <user>/<image>:<extra_tag>
```

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

Please read the [CONTRIBUTING.md](CONTRIBUTING.md) file for more details on how
to contribute to this project.

## Versioning

This project uses [SemVer](http://semver.org/) for versioning. For the versions
available, see the [tags on this repository](https://github.com/fscm/docker-tools/tags).

## Authors

* **Frederico Martins** - [fscm](https://github.com/fscm)

See also the list of [contributors](https://github.com/fscm/docker-tools/contributors)
who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE)
file for details
