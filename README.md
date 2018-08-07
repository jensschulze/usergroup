# Composer template for the Drupal Usergroup event 2018-08-30

[![Build Status](https://travis-ci.org/jensschulze/usergroup.svg?branch=master)](https://travis-ci.org/jensschulze/usergroup)

This is a _vanilla_ Drupal installation with a SQLite database. It was built in two easy steps:

 Create project with all dependencies with [Composer](https://getcomposer.org/):
```
composer create-project drupal-composer/drupal-project:8.x-dev usergroup --stability dev --no-interaction
```
Perform a _site install_
```
cd usergroup
bin/drush si -y --db-url=sqlite://sites/default/files/drupaldb.sqlite --account-name=admin --account-pass=admin --site-name="Vanilla Drupal for Usergroup event" standard install_configure_form.enable_update_status_module=NULL install_configure_form.enable_update_status_emails=NULL
```
