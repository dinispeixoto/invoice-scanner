FROM alpine:3.10

RUN apk update && apk add \
    ruby \
    imagemagick \
    tesseract-ocr \
    tesseract-ocr-data-por

WORKDIR /opt/invoice-scanner
COPY . .

RUN gem install bundler --no-ri && bundler install

EXPOSE 9292

CMD ["bundler", "exec", "rackup", "--host", "0.0.0.0"]
