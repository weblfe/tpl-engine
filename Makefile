GO_SRC := $(shell find -type f -name '*.go')
GO_PKGS := $(shell go list ./...)
VERSION ?= $(shell git describe --long --dirty)
BUILD_PROJECT := "./app/cli/cmd"
PROJECT_NAME := "tplgo"

all: vet test tplgo

tplgo: $(GO_SRC)
	CGO_ENABLED=0 GOOS=linux go build -a \
	-ldflags "-extldflags '-static' -X main.Version=$(shell git describe --long --dirty)" \
	-o $(PROJECT_NAME) $(BUILD_PROJECT)

release: $(PROJECT_NAME)-linux-arm64 $(PROJECT_NAME)-linux-x86_64 $(PROJECT_NAME)-linux-i386 $(PROJECT_NAME)-windows-i386.exe $(PROJECT_NAME)-windows-x86_64.exe $(PROJECT_NAME)-darwin-x86_64 $(PROJECT_NAME)-darwin-i386 $(PROJECT_NAME)-darwin-arm64 $(PROJECT_NAME)-freebsd-x86_64

tplgo-linux-arm64:
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -a \
    	-ldflags "-extldflags '-static' -X main.Version=$(shell git describe --long --dirty)" \
    	-o $@ $(BUILD_PROJECT)

tplgo-linux-x86_64:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a \
    	-ldflags "-extldflags '-static' -X main.Version=$(shell git describe --long --dirty)" \
    	-o $@ $(BUILD_PROJECT)

tplgo-linux-i386:
	CGO_ENABLED=0 GOOS=linux GOARCH=386 go build -a \
    	-ldflags "-extldflags '-static' -X main.Version=$(shell git describe --long --dirty)" \
    	-o $@ $(BUILD_PROJECT)

tplgo-windows-i386.exe:
	CGO_ENABLED=0 GOOS=linux GOARCH=386 go build -a \
    	-ldflags "-extldflags '-static' -X main.Version=$(shell git describe --long --dirty)" \
    	-o $@ $(BUILD_PROJECT)

tplgo-windows-x86_64.exe:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a \
    	-ldflags "-extldflags '-static' -X main.Version=$(shell git describe --long --dirty)" \
    	-o $@ $(BUILD_PROJECT)

tplgo-darwin-x86_64:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a \
    	-ldflags "-extldflags '-static' -X main.Version=$(shell git describe --long --dirty)" \
    	-o $@ $(BUILD_PROJECT)

tplgo-darwin-i386:
	CGO_ENABLED=0 GOOS=linux GOARCH=386 go build -a \
    	-ldflags "-extldflags '-static' -X main.Version=$(shell git describe --long --dirty)" \
    	-o $@ $(BUILD_PROJECT)

tplgo-darwin-arm64:
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -a \
    	-ldflags "-extldflags '-static' -X main.Version=$(shell git describe --long --dirty)" \
    	-o $@ $(BUILD_PROJECT)

tplgo-freebsd-x86_64:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a \
    	-ldflags "-extldflags '-static' -X main.Version=$(shell git describe --long --dirty)" \
    	-o $@ $(BUILD_PROJECT)


test:
	mkdir -p coverage
	go test -v -covermode=count -coverprofile=coverage/test.cov $(GO_PKGS)

vet:
	go vet $(GO_PKGS)

# Format the code
fmt:
	gofmt -s -w $(GO_SRC)

# Check code conforms to go fmt
style:
	! gofmt -s -l $(GO_SRC) 2>&1 | read 2>/dev/null

.PHONY: test vet release