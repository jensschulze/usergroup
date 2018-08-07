# Composer template for the Drupal Usergroup event 2018-08-30

[![Build Status](https://travis-ci.org/jensschulze/usergroup.svg?branch=master)](https://travis-ci.org/jensschulze/usergroup)

## What is this?
This is a _vanilla_ Drupal installation with a SQLite database. It was built in two easy steps:

 Create project with all dependencies with [Composer](https://getcomposer.org/):
```
composer create-project drupal-composer/drupal-project:8.x-dev usergroup --stability dev --no-interaction
```
Perform a _site install_. I used `drush` because I could copy+paste my own code from somewhere, but you may use `drupal console` as well. 
```
cd usergroup
vendor/bin/drush si -y --db-url=sqlite://sites/default/files/drupaldb.sqlite --account-name=admin --account-pass=admin --site-name="Vanilla Drupal for Usergroup event" standard install_configure_form.enable_update_status_module=NULL install_configure_form.enable_update_status_emails=NULL
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
 