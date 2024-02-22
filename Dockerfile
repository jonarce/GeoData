FROM postgis/postgis:latest
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD Pass@word1
ENV POSTGRES_DB postgres
ENV PGDATA /var/lib/postgresql/data/pgdata
VOLUME [ "/var/lib/postgresql/data" ]
EXPOSE 5432
