<?php

declare(strict_types=1);

$dbParameters = parse_url(getenv('DB_DSN'));

$databases['default']['default'] = [
  'host' => 'sqlite' === $dbParameters['scheme'] ? '' : $dbParameters['host'],
  'port' => $dbParameters['port'],
  'username' => $dbParameters['user'],
  'password' => $dbParameters['pass'],
  'driver' => $dbParameters['scheme'],
  'database' => mb_substr($dbParameters['path'], 1),
  'prefix' => getenv('DB_PREFIX') ?: '',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\'.$dbParameters['scheme'],
];
