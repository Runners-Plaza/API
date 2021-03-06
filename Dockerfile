FROM amberframework/amber:0.34.0

WORKDIR /app

COPY . /app

RUN shards build runners_plaza

RUN rm -rf /app/node_modules

CMD amber db migrate seed && bin/runners_plaza
