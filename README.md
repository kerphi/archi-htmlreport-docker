# archi-htmlreport-docker

[![Docker Pulls](https://img.shields.io/docker/pulls/abesesr/archi-htmlreport-docker.svg)](https://hub.docker.com/r/abesesr/archi-htmlreport-docker/)

Generates and exposes an HTML web site from a ArchiMateTool model.

We uses it internally at [Abes](http://abes.fr) to generate our "urbanization web site" helping us to know how is organized our IT system.

![Demo](doc/Screencast_07-07-2019_18_51_02.gif)

# Parameters

- `GIT_REPOSITORY` : git url of the archimatetool model (mandatory)
- `GIT_CHECK_EACH_NBMINUTES` : time to wait before checking again git repository change (default: 5 minutes)

GIT_REPOSITORY will be cloned at `/archi-model-git-repo/` location. It should have somes data at a specific location:
- `model/` containing the multi xml files generated by ArchiMateTool IDE (mandatory)
- `create-htmlreport.postscript.sh` will be executed each time the HTML report is generated juste after the generation (optional). 
- `create-htmlreport.prescript.sh` will be executed each time the HTML report is generated juste before the generation (optional). 

If you need ssh to clone GIT_REPOSITORY, then you have to share the local id_ras ssh key in the container at this place:
  - `/root/.ssh/id_rsa.orig`
  - `/root/.ssh/id_rsa.pub.orig`
The container will copy it to `/root/.ssh/id_rsa` and `/root/.ssh/id_rsa.pub` with a correct chmod.

# Internal structure

- `/archi-model-git-repo/` contains the result of `git clone $GIT_REPOSITORY`
- `/archi-model-git-repo/model.archimate` is the onefile model autogenerated by this script (source is `model/`)

# For production

```
mkdir archi-htmlreport/ && cd archi-htmlreport/
echo 'GIT_CHECK_EACH_NBMINUTES=5' > .env
echo 'GIT_REPOSITORY=git@git.abes.fr:supi/Archi.git' >> .env
wget https://raw.githubusercontent.com/abes-esr/archi-htmlreport-docker/master/docker-compose.yml
docker-compose up -d
```

Generated web site will listen on http://127.0.0.1:8080 (replace 127.0.0.1 by your server IP)

# For developers

To test it locally
```
docker build -t abesesr/archi-htmlreport-docker:1.1.4 .
docker run --rm -p 8080:80 \
  -v $(pwd)/id_rsa_archi:/root/.ssh/id_rsa.orig \
  -v $(pwd)/id_rsa_archi.pub:/root/.ssh/id_rsa.pub.orig \
  -v $(pwd)/docker-entrypoint.sh:/docker-entrypoint.sh \
  -v $(pwd)/create-htmlreport.periodically.sh:/create-htmlreport.periodically.sh \
  -e GIT_CHECK_EACH_NBMINUTES=5 \
  -e GIT_REPOSITORY="git@git.abes.fr:supi/Archi.git" \
  abesesr/archi-htmlreport-docker:1.1.4
```
To generate a new version, just uses npm version stuff. Example:
- `npm version patch` will bump the latest version number
- `npm version minor` will bump the second version number
- `npm version major` will bump the first version number
It will autobuild a new docker image thanks to the [autobuild dockerhub system](ttps://hub.docker.com/r/abesesr/archi-htmlreport-docker/).
