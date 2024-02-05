# 
class puppet_mcafee {
  archive { 'C:\\Windows\\Temp\\mcafeeclean.zip':
    ensure       => present,
    extract      => true,
    extract_path => 'c:\\Windows\\Temp',
    source       => 'https://github.com/andrew-s-taylor/public/raw/main/De-Bloat/mcafeeclean.zip',
  } ->

  file { 'C:\\Windows\\Temp\\remove_mcafee.ps1':
    ensure  => file,
    content => @(EOF),
      # Run the cleanup tool
      $program= "c:\Windows\Temp\McCleanup.exe"
      $programArg= "-p StopServices,MFSY,PEF,MXD,CSP,Sustainability,MOCP,MFP,APPSTATS,Auth,EMproxy,FWdiver,HW,MAS,MAT,MBK,MCPR,McProxy,McSvcHost,VUL,MHN,MNA,MOBK,MPFP,MPFPCU,MPS,SHRED,MPSCU,MQC,MQCCU,MSAD,MSHR,MSK,MSKCU,MWL,NMC,RedirSvc,VS,REMEDIATION,MSC,YAP,TRUEKEY,LAM,PCB,Symlink,SafeConnect,MGS,WMIRemover,RESIDUE -v -s"
      $process = Start-Process $program -ArgumentList $ProgramArg -passthru -Wait -NoNewWindow

      # Remove the Store apps from McAfee
      $RemoveApp = 'Mcafee'
      Get-AppxPackage -AllUsers | Where-Object {$_.Name -Match $RemoveApp} | Remove-AppxPackage
      Get-AppxPackage | Where-Object {$_.Name -Match $RemoveApp} | Remove-AppxPackage
      Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Match $RemoveApp} | Remove-AppxProvisionedPackage -Online
    EOF
  } ->

  exec { 'uninstall-mcafee':
    command  => 'C:/Windows/Temp/remove_mcafee.ps1',
    provider => powershell,
    onlyif   => 'Get-Service mc-wps-update | Where-Object {$_.Status -eq "Stopped"}',
  }
}
