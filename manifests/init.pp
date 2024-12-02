# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include navidrome
class navidrome (
  String $ensure,
  Boolean $enable,
  String $service_name,
  String $version,
  String $user,
  String $password,
  String $executable_dir,
  String $working_dir,
  String $ffmpeg_ensure,
  String $ffmpeg_name

) {
  include navidrome::configuration

  package { $ffmpeg_name:
    ensure => $ffmpeg_ensure,
    name   => $ffmpeg_name,
  }

  user { $user:
    ensure   => present,
    name     => $user,
    password => $password,
  }

  file { $executable_dir:
    ensure => directory,
    path   => $executable_dir,
    owner  => $user,
    group  => $user,
  }

  file { $working_dir:
    ensure => directory,
    path   => $working_dir,
    owner  => $user,
    group  => $user,
  }

  $archive_name = "navidrome_${version}_linux_amd64.tar.gz"
  $download_uri = "https://github.com/navidrome/navidrome/releases/download/v${version}/${archive_name}"
  archive { "${executable_dir}/${archive_name}":
    ensure       => $ensure,
    source       => $download_uri,
    user         => $user,
    group        => $user,
    extract      => true,
    extract_path => $executable_dir,
  }

  service { $service_name:
    ensure => $ensure,
    enable => $enable,
    name   => $service_name,
  }
}
