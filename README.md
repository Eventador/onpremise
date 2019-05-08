# Sentry On-Premise

Official bootstrap for running your own [Sentry](https://sentry.io/) with [Docker](https://www.docker.com/).

## Requirements

 * Docker 1.10.0+
 * Compose 1.6.0+ _(optional)_
 
 ## Minimum Hardware Requirements:
 
 * You need at least 3GB Ram

## Up and Running

Assuming you've just cloned this repository, the following steps
will get you up and running in no time!

There may need to be modifications to the included `docker-compose.yml` file to accommodate your needs or your environment. These instructions are a guideline for what you should generally do.

1. `docker volume create --name=sentry-data && docker volume create --name=sentry-postgres` - Make our local database and sentry volumes
    Docker volumes have to be created manually, as they are declared as external to be more durable.
2. `cp -n .env.example .env` - create env config file
3. `docker-compose build` - Build and tag the Docker services
4. `docker-compose run --rm web config generate-secret-key` - Generate a secret key.
    Add it to `.env` as `SENTRY_SECRET_KEY`.
5. `docker-compose run --rm web upgrade` - Build the database.
    Use the interactive prompts to create a user account.
6. `docker-compose up -d` - Lift all services (detached/background mode).
7. Access your instance at `localhost:9000`!

## Securing Sentry with SSL/TLS

If you'd like to protect your Sentry install with SSL/TLS, there are
fantastic SSL/TLS proxies like [HAProxy](http://www.haproxy.org/)
and [Nginx](http://nginx.org/).

## Updating Sentry

Updating Sentry using Compose is relatively simple. Just use the following steps to update. Make sure that you have the latest version set in your Dockerfile. Or use the latest version of this repository.

Use the following steps after updating this repository or your Dockerfile:
```sh
docker-compose build --pull # Build the services again after updating, and make sure we're up to date on patch version
docker-compose run --rm web upgrade # Run new migrations
docker-compose up -d # Recreate the services
```

### Custom Image

If you want to customize specific settings for your installation, build a custom `sentry` image by modifying the files `config.yml`, `Dockerfile` and `sentry.conf.py` in the `build` directory.

Then, proceed to upload the custom image to your repository of choice, as following:

```bash
REPOSITORY=some-repo/your-sentry make build push
```

If you don't want to build a custom image, you may use `script3r/sentry-k8s`.

### Prereqs

You'll need to setup a `PostgreSQL` database with a user and database designated for `sentry`.

You will also want to run the `sentry` migrations on it. For more details see https://docs.sentry.io/server/installation/docker/. 

### Deploy to Kubernetes

Taken from [script3r/sentry-k8s](https://github.com/script3r/sentry-k8s)

Modify the secrets file to contain the actual secrets used in the project. Make sure they're base64 encoded. For example, if your database name and database user are `sentry`, then your secrets file should contain:

```yaml
dbName: c2VudHJ5
dbUser: c2VudHJ5
```

To deploy to Kubernetes, simply type:

```bash
kubectl apply -f k8s/
```

Notice that this will create a namespace named `sentry`. Confirm the machines are up by typing:

```bash
kubectl get pods -nsentry
```

You should see images for `web`, `worker` and `cron`.

Enjoy! Your `sentry` is now exposed as a service `sentry-web-service` listening on port 80. It is recommended to front this with a TLS/SSL enabled proxy.


### TLS Notes

Notice that by default, this setup script enables TLS/SSL by setting the environment variable `SENTRY_USE_SSL` to `1` in `20web.yml`.

If you want to disable TLS (don't do it!), you may set this environment variable to `0`.

## Resources

 * [Documentation](https://docs.sentry.io/server/installation/docker/)
 * [Bug Tracker](https://github.com/getsentry/onpremise)
 * [Forums](https://forum.sentry.io/c/on-premise)
 * [IRC](irc://chat.freenode.net/sentry) (chat.freenode.net, #sentry)
