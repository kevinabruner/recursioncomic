<?php

$config['system.logging']['error_level'] = 'verbose';

$settings['container_yamls'][] = $app_root . '/' . $site_path . '/services.yml';


$settings['file_scan_ignore_directories'] = [
  'node_modules',
  'bower_components',
];

$settings['entity_update_batch_size'] = 50;

$settings['entity_update_backup'] = TRUE;

$settings['migrate_node_migrate_type_classic'] = FALSE;

$settings['hash_salt'] = 'thisiskindrandomiguess';

$databases['default']['default'] = array (
  'database' => '',
  'username' => '',
  'password' => '',
  'prefix' => '',
  'host' => 'localhost',
  'port' => '3306',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
);
$settings['config_sync_directory'] = 'sites/default/files/config_ciXpqQpUq-Xu3ZEcbz5ZB3OmDxY90bSKmtPG-CHuzxMGgcyFDxuYCMHwfcI8THYIkoSvDcvCnw/sync';
