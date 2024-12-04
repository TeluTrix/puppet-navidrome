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

  package { 'epel-release':
    ensure  => $package_ensure,
  }

  exec { 'enable_epel_repo':
    command => '/bin/bash -c "dnf config-manager --set-enabled epel && dnf clean all"',
    path    => ['/bin', '/usr/bin'],
    unless  => '/bin/bash -c "dnf repolist | grep -q epel"',
    require => Package['epel-release'],
  }

# Add the RPM Fusion repositories
  exec { 'add_rpmfusion_repo_free':
    command => '/bin/bash -c "dnf install -y https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm"',
    path    => ['/bin', '/usr/bin'],
    creates => '/etc/yum.repos.d/rpmfusion-free.repo',
    require => Exec['enable_epel_repo'],
  }

  exec { 'add_rpmfusion_repo_non_free':
    command => '/bin/bash -c "dnf install -y https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-9.noarch.rpm"',
    path    => ['/bin', '/usr/bin'],
    creates => '/etc/yum.repos.d/rpmfusion-nonfree.repo',
    require => Exec['enable_epel_repo'],
  }

  # Install the necessary packages (ffmpeg)
  package { $ffmpeg_name:
    ensure          => $ffmpeg_ensure,
    install_options => ['--allowerasing'],
    require         => [Exec['add_rpmfusion_repo_free'], Exec['add_rpmfusion_repo_non_free']],
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
