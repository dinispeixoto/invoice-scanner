FROM ruby:2.6.5-alpine3.10

RUN apk update && apk add \
    bash \ 
    imagemagick \
    tesseract-ocr \
    tesseract-ocr-data-por

WORKDIR /opt/invoice-scanner
COPY . .

RUN gem install bundler && bundler install

EXPOSE 9292

CMD ["bundler", "exec", "rackup", "--host", "0.0.0.0"]
