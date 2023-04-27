FROM cgr.dev/chainguard/go:1.20 as builder
#RUN apk add --no-cache make
ENV GOOS=linux
ENV CGO_ENABLED=0
ENV GO111MODULE=on
COPY . /app
WORKDIR /app
RUN make slsa-workshop

FROM cgr.dev/chainguard/static:latest
COPY --from=builder /app/bin/slsa-workshop /slsa-workshop
ENTRYPOINT [ "/slsa-workshop" ]
