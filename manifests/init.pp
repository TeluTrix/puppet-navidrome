# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include navidrome
class navidrome (
  Optional[String]  $ensure,
  Optional[Boolean] $enable,
  Optional[String]  $service_name,
  Optional[String]  $version,
  Optional[String]  $user,
  Optional[String]  $password,
  Optional[String]  $executable_dir,
  Optional[String]  $working_dir,
  Optional[String]  $ffmpeg_ensure,
  Optional[String]  $ffmpeg_name

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
    ensure       => 'present',
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
