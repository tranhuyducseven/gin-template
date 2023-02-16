FROM golang:1.19-alpine AS builder

ARG APP_NAME=template-server

WORKDIR /app

COPY . .

RUN CGO_ENABLED=0 go build -o ./$APP_NAME

# Run
FROM alpine:3.14
WORKDIR /app
COPY --from=builder /app/$APP_NAME .
RUN apk add --no-cache tzdata
EXPOSE 8080

CMD /app/template-server
