FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    ruby \
    rubygems \
    imagemagick \
    tesseract-ocr \
    tesseract-ocr-por

WORKDIR /opt/invoice-scanner
COPY . .

RUN gem install bundler && bundler install

EXPOSE 9292

CMD ["bundler", "exec", "rackup", "--host", "0.0.0.0"]
