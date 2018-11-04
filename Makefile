version = 0.1
user = mrbuk
project = myip-resource

all: build save
.PHONY : all

build:
	docker build . -t ${user}/${project}:$(version) -t ${user}/${project}:latest

push: build
	docker push ${user}/${project}:$(version)
	docker push ${user}/${project}:latest

save:
	mkdir -p images
	docker save ${user}/${project}:latest -o images/${user}_${project}_latest.tgz
