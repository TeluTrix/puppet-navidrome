# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @param ensure
#   standard ensure parameter
# @param enable
#   standard enable parameter
# @param service_name
#   service name for the navidrome systemd service
# @param version
#   provide navidrome version (default -> latest)
# @param user
#   system username for navidrome user
# @param group
#   system group for navidrom user
# @param password
#   system user password for navidrome user
# @param executable_dir
#   executable directory for the navidrome app
# @param working_dir
#   working directory for the navidrome app
# @param ffmpeg_ensure
#   ensure param for ffmpeg package
# @param ffmpeg_name
#   name of ffmpeg package
#   include navidrome
class navidrome (
  Optional[String]  $ensure,
  Optional[Boolean] $enable,
  Optional[String]  $service_name,
  Optional[String]  $version,
  Optional[String]  $user,
  Optional[String]  $group,
  Optional[String]  $password,
  Optional[String]  $executable_dir,
  Optional[String]  $working_dir,
  Optional[String]  $ffmpeg_ensure,
  Optional[String]  $ffmpeg_name

) {
  include navidrome::configuration

  package { 'epel-release':
    ensure  => $ensure,
  }

  exec { 'enable_epel_repo':
    command => '/bin/bash -c "dnf config-manager --set-enabled epel && dnf clean all"',
    path    => ['/bin', '/usr/bin'],
    unless  => '/bin/bash -c "dnf repolist | grep -q epel"',
    require => Package['epel-release'],
  }

  # Enable CRB (CodeReady Builder) repository
  exec { 'enable_crb_repo':
    command => '/bin/bash -c "dnf config-manager --set-enabled crb"',
    path    => ['/bin', '/usr/bin'],
    unless  => '/bin/bash -c "dnf repolist | grep -q crb"',
    require => Exec['enable_epel_repo'],
  }

  # Add the RPM Fusion repositories
  exec { 'add_rpmfusion_repo_free':
    command => '/bin/bash -c "dnf install -y https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm"',
    path    => ['/bin', '/usr/bin'],
    creates => '/etc/yum.repos.d/rpmfusion-free.repo',
    require => Exec['enable_crb_repo'],
  }

  exec { 'add_rpmfusion_repo_non_free':
    command => '/bin/bash -c "dnf install -y https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-9.noarch.rpm"',
    path    => ['/bin', '/usr/bin'],
    creates => '/etc/yum.repos.d/rpmfusion-nonfree.repo',
    require => Exec['enable_crb_repo'],
  }

  # Install the necessary packages (vlc, ffmpeg, jellyfin)
  package { $ffmpeg_name:
    ensure          => $ffmpeg_ensure,
    install_options => ['--allowerasing'],
    require         => [Exec['add_rpmfusion_repo_free'], Exec['add_rpmfusion_repo_non_free']],
  }

  user { $user:
    ensure   => present,
    name     => $user,
    groups   => [$group],
    password => $password,
  }

  file { $navidrome::configuration::music_folder:
    ensure => directory,
    path   => $navidrome::configuration::music_folder,
    owner  => $user,
    group  => $group,
  }

  file { $executable_dir:
    ensure => directory,
    path   => $executable_dir,
    owner  => $user,
    group  => $group,
  }

  file { $working_dir:
    ensure => directory,
    path   => $working_dir,
    owner  => $user,
    group  => $group,
  }

  $archive_name = "navidrome_${version}_linux_amd64.tar.gz"
  $download_uri = "https://github.com/navidrome/navidrome/releases/download/v${version}/${archive_name}"
  archive { "${executable_dir}/${archive_name}":
    ensure       => 'present',
    source       => $download_uri,
    user         => $user,
    group        => $group,
    extract      => true,
    extract_path => $executable_dir,
  }

  service { $service_name:
    ensure => $ensure,
    enable => $enable,
    name   => $service_name,
  }

  if !$navidrome::configuration::port {
    $port = 4533
  } else {
    $port = $navidrome::configuration::port
  }

  # Enable port in firewall
  firewalld_port { 'Open port for navidrome to the public':
    ensure   => present,
    zone     => 'public',
    port     => $port,
    protocol => 'tcp',
  }

  # Make sure firewalld is running
  service { 'firewalld':
    ensure => running,
    enable => true,
    name   => 'firewalld',
  }
}
