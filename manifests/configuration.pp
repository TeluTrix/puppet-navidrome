# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include navidrome::configuration
class navidrome::configuration (
  String  $music_folder,
  String  $data_folder,
  Enum['warn', 'info', 'debug', 'trace'] $log_level,
  String  $scan_schedule,
  String  $transcoding_cache_size,
  String  $cache_folder,
  String  $address,
  String  $base_url,
  Integer $port,
  String  $systemd_description,
  String  $systemd_path,
  String  $systemd_after,
  String  $systemd_user,
  String  $systemd_wantedby,
  String  $systemd_type,
  String  $systemd_navidrome_location,
  String  $systemd_settings_location,
  String  $systemd_working_dir,
  Integer $systemd_timeout_stop_sec,
  String  $systemd_killmode,
  String  $systemd_restart,
) {
  file { '/var/lib/navidrome/configuration.toml':
    ensure  => file,
    content => epp('navidrome/configuration.toml.epp', {
        'systemd_description'        => $systemd_description,
        'systemd_path'               => $systemd_path,
        'systemd_after'              => $systemd_after,
        'systemd_user'               => $systemd_user,
        'systemd_wantedby'           => $systemd_wantedby,
        'systemd_type'               => $systemd_type,
        'systemd_navidrome_location' => $systemd_navidrome_location,
        'systemd_settings_location'  => $systemd_settings_location,
        'systemd_working_dir'        => $systemd_working_dir,
        'systemd_timeout_stop_se'    => $systemd_timeout_stop_sec,
        'systemd_killmode'           => $systemd_killmode,
        'systemd_restart'            => $systemd_restart,
    }),
  }

  file { '/etc/systemd/system/navidrome.service':
    ensure  => file,
    content => epp('navidrome/navidrome.service.epp', {
        'music_folder'           => $music_folder,
        'data_folder'            => $data_folder,
        'log_level'              => $log_level,
        'scan_schedule'          => $scan_schedule,
        'transcoding_cache_size' => $transcoding_cache_size,
        'cache_folder'           => $cache_folder,
        'address'                => $address,
        'base_url'               => $base_url,
        'port'                   => $port,
    }),
  }
}
