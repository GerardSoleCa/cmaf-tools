# cmaf-tools
This repository contains the Dockerfile to build the Docker image containing all the tools required to build cmaf packages, and test their capabilities.
It has been used and built during my master thesis, to simplify and restrict the required environment to work with the encoding tools.

It can be pulled from the hub repository with the following command:
```bash
$ docker pull gerardsoleca/cmaf-tools
```

The included software within the image is:
* ffmpeg
* mediainfo
* vim
* Shacka Packager
* Bento4

The image can be built from its source by running the following command:
```bash
$ docker build -t cmaf-tools .
```

