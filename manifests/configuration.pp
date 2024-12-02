# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include navidrome::configuration
class navidrome::configuration (
  Optional[String]  $music_folder,
  Optional[String]  $data_folder,
  Optional[Enum['warn', 'info', 'debug', 'trace']] $log_level,
  Optional[String]  $scan_schedule,
  Optional[String]  $transcoding_cache_size,
  Optional[String]  $cache_folder,
  Optional[String]  $address,
  Optional[String]  $base_url,
  Optional[Integer] $port,
  Optional[String]  $systemd_description,
  Optional[String]  $systemd_path,
  Optional[String]  $systemd_after,
  Optional[String]  $systemd_user,
  Optional[String]  $systemd_wantedby,
  Optional[String]  $systemd_type,
  Optional[String]  $systemd_navidrome_location,
  Optional[String]  $systemd_settings_location,
  Optional[String]  $systemd_working_dir,
  Optional[Integer] $systemd_timeout_stop_sec,
  Optional[String]  $systemd_killmode,
  Optional[String]  $systemd_restart,
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
