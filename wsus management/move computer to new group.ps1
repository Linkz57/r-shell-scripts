$me = Invoke-Command {whoami.exe}
$session = New-PSSession -ComputerName wsus -Credential $me
Invoke-Command -Session $session -ScriptBlock {

    Get-WsusComputer -ComputerTargetGroups "Unassigned Computers" | Out-Default
    #Write-Output $listcomputers
    $usercomputer = Read-Host -Prompt 'Which of those machines do you wnat to move? Include FQDN.'

    $server = Get-WsusServer -name wsus -portnumber 8531
    $computer = $server.getcomputertargetbyname($usercomputer)

    $server.getcomputertargetgroups() | Format-Table name, id
    $usergroup = Read-Host -Prompt 'Which of those groups do you wnat to move to? Paste in the ID with no spaces.'

    $newgroup = $server.getcomputertargetgroup($usergroup)
    $newgroup.addcomputertarget($computer)

}
