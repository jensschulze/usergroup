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
Ok! We are here because we want to dockerize Drupal. But … let's sneak a peek :D
```bash
vendor/bin/drupal rs -v
```  

## Admin Access
|      |           |
|------|-----------|
| User | **admin** |
| Password | **admin** |
 