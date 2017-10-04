VERSION?=latest
L?=ru
JVM?=8

all: build push

build:
	docker build -t cnsa/freeling-jvm:${L}.${VERSION} ./${JVM}.x/${L}

push:
	docker push cnsa/freeling-jvm:${L}.${VERSION}
