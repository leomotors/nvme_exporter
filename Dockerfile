FROM golang:1.22-bookworm as builder

WORKDIR /app

COPY . ./

RUN go mod download

# Build
RUN CGO_ENABLED=0 GOOS=linux go build -o nvme_exporter ./main.go

FROM debian:bookworm as RUNNER

RUN apt-get update
RUN apt-get -y install nvme-cli

WORKDIR /app

COPY --from=builder /app/nvme_exporter .

EXPOSE 9998

CMD [ "./nvme_exporter" ]
