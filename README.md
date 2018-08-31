# Basic Drupal for the Drupal Usergroup event 2018-08-30

## What is this?
This is a _vanilla_ Drupal installation with a SQLite database. It was built in three easy steps:

### What we have done so far

* Create project with all dependencies with [Composer](https://getcomposer.org/):
```bash
composer create-project drupal-composer/drupal-project:8.x-dev usergroup --stability dev --no-interaction
```

* Perform a _site install_. I used the `drupal` console command because we highly recommend using it, but you may use `drush` as well. 
```bash
cd usergroup
vendor/bin/drupal si standard \
    --langcode="en" \
    --db-type="sqlite" \
    --db-file="sites/default/files/drupaldb.sqlite " \
    --account-name=admin \
    --account-pass=admin \
    --account-mail=admin@example.com \
    --site-name="Vanilla Drupal for Usergroup event" \
    --site-mail="admin@example.com"
```

* Add a `web/sites/default/settings.local.php`, remove it from `.gitignore`, and include it in `web/sites/default/settings.php`.

## Preparation
* Copy `.env.dist` to `.env`.
```bash
cp .env.dist .env
```
The environment variables defined in the `.env` file will be accessible in Drupal via `load.environment.php` which is called as soon as the Composer Autoloader is required in the Front Controller `web/index.php`.

☝️ Please have a look at `.env` and `settings.local.php`: this is how we define the database via an environment variable.

* Install dependencies
```bash
composer install
```

## Running Drupal
Ok! We are here because we want to dockerize Drupal. But … let's sneak a peek 😉
```bash
vendor/bin/drupal rs -v
```  

### Admin Access
|      |           |
|------|-----------|
| User | **admin** |
| Password | **admin** |

## Dockerize Drupal
### Dockerfile
The Dockerfile should be self-explanatory. We start with the official Image for Apache 2.4 with mod_php 7.2. Then we have to build several PHP extensions (namely _ext-gd_, _ext-opcache_, _ext-pdo-mysql_, and _ext-zip_). In order to compile ext-gd we have to install a few libraries first (_libjpeg-dev_, _libpng-dev_, and _libpq-dev_).

After this we tweak the configuration of the Opcache extension and PHP itself. Then we create an Apache vhost configuration for our Drupal site.

In the next steps we install the dependencies defined in `composer.json`, copy the complete project into the Docker image, and generate the Composer autoloader.

Finally we set the ownership for files and directories Apache/PHP has to write into.

### Build the Image
Build the Docker image with
```bash
docker build -t usergroup/drupal:local-dev .
```

Check if you can find this image in your local registry:
```bash
docker images
```

### Start the container
Now that you have an image you can start a container!
```bash
docker run --rm -e DB_DSN=sqlite://:@xxx/sites/default/files/drupaldb.sqlite -p 80:80 usergroup/drupal:local-dev
```

The `--rm` switch automatically removes the container on exit.

With `-e` we can pass environment variables to the container.

With `-p 80:80` we expose TCP port 80 of the container on port 80 on the host. Therefore you can access your Drupal site at `127.0.0.1`. Have fun!

### Next step: Docker compose
With Docker compose you can operate a whole stack instead of single containers. The `docker-compose.yml` file contains the stack definition.

You can even build the images of your stack with
```bash
docker-compose build
```

The image name and the build context are already defined in the `docker-compose.yml`.

#### Simple (only one container)
Even with a single container Docker compose is a very convenient tool.
 
Instead of the cumbersome `docker run …` you may simply use
```bash
docker-compose up web-php
```

Keep in mind to manually remove the container with
```bash
docker-compose down
```

#### A bit more advanced
Let’s try to use MariaDB instead of SQLite! It’s already preconfigured in the `docker-compose.yml` file, so all you have to do is to change the environment variable `DB_DSN` in `.env`, and then start the whole stack with
```bash
docker-compose up
```

This is even simpler than starting only one service of the stack! Turn off and remove the whole stack with `docker-compose down`.

## Questions
1. The data we store in the database is persistent: We can down and up the stack again – and our Drupal installation is still there. The database files must exist somewhere on the host (your local machine). But where are they?
2. * At the moment any changes in your host filesystem won’t propagate into the container. If you do not want to build the container everytime you have changed something, you have to mount some host directories into the container. Let’s start with `web/modules/custom`. See how it is done in the `web-db` part in `docker-compose.yml`!
   * Changes in your container filesystem (maybe you want to upload a photo) should most likely change your host file system. Mount the respective directories, too.
