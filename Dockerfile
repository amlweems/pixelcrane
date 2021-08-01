FROM golang AS build
WORKDIR /app
ADD go.* ./
RUN go mod download
ADD . .
RUN CGO_ENABLED=0 go build -trimpath

FROM alpine
RUN apk --update add \
 bash \
 git
COPY --from=build /app/pixelcrane /bin/
ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
