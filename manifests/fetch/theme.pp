define ohmyzsh::fetch::theme (
  $filename,
  $user,
  $url = 'UNSET',
  $source = 'UNSET',
  $content = 'UNSET',
) {

  validate_string($filename, $url, $source, $content, $user)

  if $user == 'root' {
    $home = '/root'
  } else {
    $home = "/home/${user}"
  }

  $themepath = "${home}/.oh-my-zsh/custom/themes"
  $fullpath = "${themepath}/${filename}"

  if ! defined(File[$themepath]) {
    file { $themepath:
      ensure  => directory,
      owner   => $user,
      require => Ohmyzsh::Install[$name],
    }
  }

  if $url != 'UNSET' {
    wget::fetch { "ohmyzsh::fetch-${user}-${filename}":
      source      => $url,
      destination => $fullpath,
      user        => $user,
      require     => File[$themepath],
    }
  } elsif $source != 'UNSET' {
    file { $fullpath:
      ensure  => present,
      source  => $source,
      owner   => $user,
      require => File[$themepath],
    }
  } elsif $content != 'UNSET' {
    file { $fullpath:
      ensure  => present,
      content => $content,
      owner   => $user,
      require => File[$themepath],
    }
  } else {
    fail('No valid option set.')
  }

}
