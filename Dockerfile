FROM golang:1.21-alpine as builder
ENV GOOS=linux
ENV CGO_ENABLED=0
ENV GO111MODULE=on
COPY . /app
WORKDIR /app
RUN make slsa-workshop

FROM gcr.io/distroless/static-debian11:nonroot
COPY --from=builder /app/bin/slsa-workshop /slsa-workshop
ENTRYPOINT [ "/slsa-workshop" ]
