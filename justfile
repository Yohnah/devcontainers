set default-list := true
set quiet

registry := "ghcr.io/yohnah"
project_file :="project.yml"

init:
	docker buildx create --use --name crossbuilder --driver docker-container --config buildkitd.toml

login user:
	docker login ghcr.io -u {{user}}

build-all version="dev" upload="false":
	#!/bin/bash
	set -e
	IMAGES=$(yq eval '.config.containers | keys | .[]' {{project_file}})
	for image in $IMAGES; do
		echo "== Building $image =="
		just build $image {{version}} {{upload}}
	done

tag-all version as="latest":
	#!/bin/bash
	set -e
	IMAGES=$(yq eval '.config.containers | keys | .[]' {{project_file}})
	

build image version="dev" upload="false":
	#!/bin/bash
	set -e
	NO_SUPPORTED_PLATFORMS=$(yq eval '.config.containers.{{image}}.no_platforms' {{project_file}})
	PLATFORMS=$(docker buildx inspect --bootstrap | grep "Platforms" | cut -d: -f2 | tr -d ' ' | sed "s#,$NO_SUPPORTED_PLATFORMS##g; s#$NO_SUPPORTED_PLATFORMS,##g" )
	PUSH_FLAG="{{ if upload == "true" { "--push" } else { "--load" } }}"
	docker buildx build --no-cache --platform $PLATFORMS \
		--build-arg IMAGE="$(yq eval '.config.containers.{{image}}.image' {{project_file}})" \
		--build-arg DISTNAME="$(yq eval '.config.containers.{{image}}.image' {{project_file}} | cut -d: -f1)" \
		--build-arg AUTHOR="$(yq eval '.author' {{project_file}})" \
		--build-arg LICENSE="$(yq eval '.license' {{project_file}})" \
		--build-arg SOURCE="$(yq eval '.source' {{project_file}})" \
		--build-arg USERS="$(yq eval '.config.users' -o=json -I=0 {{project_file}})" \
		--build-arg SCRIPT_BASE="$(yq eval '.config.containers.{{image}}.scripts.base' {{project_file}})" \
		--build-arg SCRIPT_SETUP="$(yq eval '.config.containers.{{image}}.scripts.setup' {{project_file}})" \
		--build-arg SCRIPT_SHELL="$(yq eval '.config.containers.{{image}}.scripts.shell' {{project_file}})" \
		-t {{registry}}/dev-{{image}}:{{version}} \
		-f Containerfile \
		$PUSH_FLAG .

run image version="dev":
	docker run -it {{registry}}/dev-{{image}}:{{version}} /bin/bash

inspect image version="dev":
	docker image inspect {{registry}}/dev-{{image}}:{{version}}

tag image version as="latest":
	docker buildx imagetools create \
		-t {{registry}}/dev-{{image}}:{{as}} \
		{{registry}}/dev-{{image}}:{{version}}

clean:
	#!/bin/bash
	docker buildx rm crossbuilder