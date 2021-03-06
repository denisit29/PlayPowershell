function global:Get-FailedSQLAgentJobs([string]$Instance){
#$server="Win7NetBook"
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | out-null
$SMOserver = New-Object (’Microsoft.SqlServer.Management.Smo.Server’) -argumentlist $Instance
$SMOJobs = $SMOserver.JobServer.Jobs
$SMOJobs | where {$_.LastRunOutcome -ne "Succeeded"} | select Parent, Name, IsEnabled, LastRunOutcome, LastRunDate, HasSchedule, NextRunDate, DateCreated
}#Get-FailedSQLAgentJobs
