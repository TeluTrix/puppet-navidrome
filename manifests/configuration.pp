# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @param music_folder
#   folder where the music is located
# @param data_folder
#   folder where the data is located
# @param log_level
#   log level used by navidrome
# @param scan_schedule
#   defined how often navidrome scans for new media
# @param transcoding_cache_size
#   defined the cache size reserved for transcoding
# @param cache_folder
#   folder where the cache for the navidrome app is located
# @param address
#   address for the navidrome application
# @param base_url
#   base url for the navidrome application
# @param port
#   port on which the navidrome app is running
# @param reverse_proxy_whitelist
#   whitelist of headers for the reverse proxy
# @param lastfm_api_key
#   api key for the lastfm integration
# @param lastfm_api_secret
#   api secret for the lastfm integration
# @param spotify_id
#   spotify id used for the spotify integration
# @param spotify_secret
#   spotify secret used for the spotify integration
# @param systemd_description
#   description of the systemd service
# @param systemd_path
#   location of the systemd service
# @param systemd_after
#   after parameter of systemd service
# @param systemd_wantedby
#   systemd wanted by parameter of systemd service
# @param systemd_user
#   user used for running the systemd service
# @param systemd_type
#   type of systemd service
# @param systemd_navidrome_location
#   location of navidrome binary
# @param systemd_settings_location
#   location of navidrome settings
# @param systemd_working_dir
#   working directory of the systemd service
# @param systemd_timeout_stop_sec
#   timeout stop sec parameter of systemd service
# @param systemd_killmode
#   killmode parameter of systemd service
# @param systemd_restart
#   systemd service restart behaviour
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
  Optional[Array[String]]  $reverse_proxy_whitelist,
  Optional[String]  $lastfm_api_key,
  Optional[String]  $lastfm_api_secret,
  Optional[String]  $spotify_id,
  Optional[String]  $spotify_secret,
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
  file { '/var/lib/navidrome/navidrome.toml':
    ensure  => file,
    content => epp('navidrome/navidrome.toml.epp', {
        'music_folder'            => $music_folder,
        'data_folder'             => $data_folder,
        'log_level'               => $log_level,
        'scan_schedule'           => $scan_schedule,
        'transcoding_cache_size'  => $transcoding_cache_size,
        'cache_folder'            => $cache_folder,
        'address'                 => $address,
        'base_url'                => $base_url,
        'port'                    => $port,
        'reverse_proxy_whitelist' => $reverse_proxy_whitelist,
        'lastfm_api_key'          => $lastfm_api_key,
        'lastfm_api_secret'       => $lastfm_api_secret,
        'spotify_id'              => $spotify_id,
        'spotify_secret'          => $spotify_secret,
    }),
    owner   => $navidrome::user,
    group   => $navidrome::user,
  }

  file { '/etc/systemd/system/navidrome.service':
    ensure  => file,
    content => epp('navidrome/navidrome.service.epp', {
        'systemd_description'        => $systemd_description,
        'systemd_path'               => $systemd_path,
        'systemd_after'              => $systemd_after,
        'systemd_user'               => $systemd_user,
        'systemd_group'              => $navidrome::group,
        'systemd_wantedby'           => $systemd_wantedby,
        'systemd_type'               => $systemd_type,
        'systemd_navidrome_location' => $systemd_navidrome_location,
        'systemd_settings_location'  => $systemd_settings_location,
        'systemd_working_dir'        => $systemd_working_dir,
        'systemd_timeout_stop_sec'   => $systemd_timeout_stop_sec,
        'systemd_killmode'           => $systemd_killmode,
        'systemd_restart'            => $systemd_restart,
    }),
  }
}
