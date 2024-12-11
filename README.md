# navidrome

This is a puppet module for navidrome.

Navidrome repository: https://github.com/navidrome/navidrome

## Common purpose
Navidrome is a music streaming server written in go. It is comaptible with the subsonic api.

## Compatibility
This module was tested on an AlmaLinux 9 system. It should work on most newer RHEL operating systems.

## Installation
Run the following command on your puppet server to install the navidrome module:
```bash
puppet module install g3ntlef0x-navidrome
```

## Usage examples
Import class in your manifest file:
```yaml
include navidrome
```

To configure navidrome, most default options can be used.
However, make sure to at least set the following options:
```yaml
---
navidrome::configuration::base_url: 'https://example.com'
navidrome::configuration::scan_schedule: '@every 2h'
navidrome::configuration::lastfm_api_key: 'xxx'
navidrome::configuration::lastfm_api_secret: 'xxx'
navidrome::configuration::spotify_id: 'xxx'
navidrome::configuration::spotify_secret: 'xxx
```
The spotify and lastfm options are optional. Lastfm and the spotify api are used to retrieve artworks and covers.

## Configuration options
All currently available configuration options and their default values are listed here:
```yaml
---
navidrome::version: '0.53.3'
navidrome::user: &user 'navidrome'
navidrome::ensure: running
navidrome::enable: true
navidrome::service_name: 'navidrome'
navidrome::password: 'navidromepwd'
navidrome::executable_dir: '/opt/navidrome'
navidrome::working_dir: &working_dir '/var/lib/navidrome'
navidrome::ffmpeg_ensure: present
navidrome::ffmpeg_name: 'ffmpeg'
navidrome::configuration::music_folder: '/var/data/music'
navidrome::configuration::log_level: 'debug'
navidrome::configuration::scan_schedule: '@every 12h'
navidrome::configuration::transcoding_cache_size: '150MiB'
navidrome::configuration::systemd_description: 'Systemd service for the navidrome application'
navidrome::configuration::systemd_path: *working_dir
navidrome::configuration::systemd_after: 'remote-fs.target network.target'
navidrome::configuration::systemd_user: *user
navidrome::configuration::systemd_wantedby: 'multi-user.target'
navidrome::configuration::systemd_type: 'simple'
navidrome::configuration::systemd_navidrome_location: '/opt/navidrome/navidrome'
navidrome::configuration::systemd_settings_location: '/var/lib/navidrome/navidrome.toml'
navidrome::configuration::systemd_working_dir: *working_dir
navidrome::configuration::systemd_timeout_stop_sec: 20
navidrome::configuration::systemd_killmode: 'process'
navidrome::configuration::systemd_restart: 'on-failure'
navidrome::configuration::data_folder:
navidrome::configuration::cache_folder:
navidrome::configuration::address:
navidrome::configuration::base_url:
navidrome::configuration::port:
navidrome::configuration::reverse_proxy_whitelist:
navidrome::configuration::lastfm_api_key:
navidrome::configuration::lastfm_api_secret:
navidrome::configuration::spotify_id:
navidrome::configuration::spotify_secret:
```
