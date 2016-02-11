

gx:
	go get -u github.com/whyrusleeping/gx
	go get -u github.com/whyrusleeping/gx-go

deps: gx
	gx --verbose install --global

build: deps
	go build

install: build
	go install

clean:
	go clean

