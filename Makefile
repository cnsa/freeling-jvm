VERSION?=latest

all: build push

build:
	docker build -t cnsa/freeling-jvm:${VERSION} .

push:
	docker push cnsa/freeling-jvm:${VERSION}
