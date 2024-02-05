# 
class mcafee {
  archive { 'c:\\Windows\\Temp\\mcafeeclean.zip':
    ensure        => present,
    extract       => true,
    extract_path  => 'c:\\Windows\\Temp',
    source        => 'https://github.com/andrew-s-taylor/public/raw/main/De-Bloat/mcafeeclean.zip',
  }

  file { 'C:/Windows/Temp/remove_mcafee.ps1':
    ensure => present,
    source => 'puppet:///modules/it4smart-mcafee/remove_mcafee.ps1',
  }

  exec { 'uninstall-mcafee':
    command   => file('C:\\Windows\\Temp\\remove_mcafee.ps1'),
    provider  => powershell,
    onlyif    => 'Get-Service mc-wps-update | Where-Object {$_.Status -eq "Stopped"}',
  }
}
