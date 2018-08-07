FROM ruby:latest

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs file imagemagick git && \
    apt-get clean && \ 
    rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-password --gecos "FRAB" --uid 1000 frab

COPY . /home/frab/app
RUN chown -R frab:frab /home/frab/app

USER frab

WORKDIR /home/frab/app

RUN bundle install

RUN cp config/database.yml.template config/database.yml

VOLUME /home/frab/app/public

EXPOSE 3000

ENV RACK_ENV=production \
    SECRET_KEY_BASE=asdkjf3245jsjwaA§W$W$4aw44rW$$akjq435jadsgjlkq4j5jwj45jasdjvlj \
    FRAB_HOST=localhost \
    FRAB_PROTOCOL=http \
    RAILS_SERVE_STATIC_FILES=true \
    CAP_USER=frab \
    FROM_EMAIL=frab@localhost \
    SMTP_ADDRESS=172.17.0.1 \
    SMTP_PORT=25 \
    SMTP_NOTLS=true \
    DATABASE_URL=sqlite3://localhost/home/frab/data/database.db

CMD ["/home/frab/app/docker-cmd.sh"]
