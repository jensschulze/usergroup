# Composer template for the Drupal Usergroup event 2018-08-30

[![Build Status](https://travis-ci.org/jensschulze/usergroup.svg?branch=master)](https://travis-ci.org/jensschulze/usergroup)

## What is this?
This is a _vanilla_ Drupal installation with a SQLite database. It was built in two easy steps:

 Create project with all dependencies with [Composer](https://getcomposer.org/):
```
composer create-project drupal-composer/drupal-project:8.x-dev usergroup --stability dev --no-interaction
```
Perform a _site install_. I used the `drupal` console command because we highly recommend using it, but you may use `drush` as well. 
```
cd usergroup
vendor/bin/drupal si standard \
    --langcode="en" \
    --db-type="sqlite" \
    --db-file="sites/deault/files/drupaldb.sqlite " \
    --account-name=admin \
    --account-pass=admin \
    --account-mail=admin@example.com \
    --site-name="Vanilla Drupal for Usergroup event" \
    --site-mail="admin@example.com"
```

## Running Drupal
Ok! We are here because we want to dockerize Drupal. But … let's sneak a peek :D
```
vendor/bin/drupal rs -v
```  

## Admin Access
|      |           |
|------|-----------|
| User | **admin** |
| Password | **admin** |
 