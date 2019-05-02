FROM golang:alpine AS builder

# Set the working directory outside $GOPATH to enable the support for modules.
WORKDIR /src

# Import the code from the context.
COPY ./ ./
RUN go get -u github.com/gin-gonic/gin
RUN go get -u github.com/go-sql-driver/mysql
RUN CGO_ENABLED=0 go build \
    -installsuffix 'static' \
    -o /app .

# Final stage: the running container.
FROM alpine AS final

# Import the compiled executable from the first stage.
COPY --from=builder /app /app

# Declare the port on which the webserver will be exposed.
# As we're going to run the executable as an unprivileged user, we can't bind
# to ports below 1024.
EXPOSE 8080
ENV DB_USER=root
ENV DB_PASSWORD=DB_PASSWORD
ENV DB_HOST=mysql
ENV DB_NAME=app
# Run the compiled binary.
ENTRYPOINT ["/app"]