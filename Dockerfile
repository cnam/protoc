FROM buildpack-deps:jessie

RUN apt-get update \
    && apt-get install -y --no-install-recommends unzip \
    && apt-get install -y --no-install-recommends golang-go \
    && rm -rf /var/lib/apt/lists/*

ENV PROTOBUF_VERSION 3.0.0-beta-1
RUN curl -Ls https://github.com/google/protobuf/archive/v$PROTOBUF_VERSION.tar.gz -o protobuf-$PROTOBUF_VERSION.tar.gz \
    && tar xzf protobuf-$PROTOBUF_VERSION.tar.gz \
    && cd protobuf-$PROTOBUF_VERSION \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make check \
    && make install \
    && cd ../ \
    && rm -rf protobuf-$PROTOBUF_VERSION.tar.gz protobuf-$PROTOBUF_VERSION \
    && ldconfig
  
ENV GOPATH /usr/local

RUN go get -u github.com/golang/protobuf/proto \
              github.com/golang/protobuf/protoc-gen-go 

WORKDIR /data

VOLUME ["/data"]

ENTRYPOINT ["/usr/local/bin/protoc", "-I", "/data"]
