param([switch]$OutPutToGridView)

$Metadata = @{
	Title = "Report SharePoint Securable Object Permissions"
	Filename = "Report-SPSecurableObjectPermissions.ps1"
	Description = ""
	Tags = "powershell, sharepoint, function, report"
	Project = ""
	Author = "Janik von Rotz"
	AuthorEMail = "contact@janikvonrotz.ch"
	CreateDate = "2013-03-14"
	LastEditDate = "2013-03-14"
	Version = "1.0.0"
	License = @'
This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/3.0/ or
send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.
'@
}

<#
#--------------------------------------------------#
# Example
#--------------------------------------------------#
 
.\Report-SPSecurableObjectPermissions -OutPutToGreadView

$Report = .\Report-SPSecurableObjectPermissions.ps1 -OutPutToGreadView
 
#>

#--------------------------------------------------#
# Includes
#--------------------------------------------------#
if ((Get-PSSnapin “Microsoft.SharePoint.PowerShell” -ErrorAction SilentlyContinue) -eq $null) {
    Add-PSSnapin “Microsoft.SharePoint.PowerShell”
}

#--------------------------------------------------#
# Main
#--------------------------------------------------#
$SPSite = Get-SPSite
$SPSite = Get-SPSite ([string]$Spsite[0].Url)
$SPWeb = $SPSite.AllWebs

$SPSecurableObjectPermissionReport = @()

function New-SPReportItem {
    param(
        $Name,
        $Url,
        $Member,
        $PermissionMask,
        $Type
    )
    New-Object PSObject -Property @{
        Name = $Name
        Url = $Url
        Member = $Member
        PermissionMask =$PermissionMask
        Type =$Type
    }
}

#Loop through each subsite and write permissions
foreach ($SPWebItem in $SPWeb)
{
   
    $IsUnique = $SPWebItem.HasUniqueRoleAssignments
    if (($SPWebItem.permissions -ne $null) -and  ($IsUnique -eq “True”)){
        
        foreach ($PermissionItem in $SPWebItem.permissions){
            $WriteHostItem = $SPWebItem.url
            Write-Host "Item: $WriteHostItem" -BackgroundColor Yellow -ForegroundColor Black
            $SPSecurableObjectPermissionReport += New-SPReportItem -Name $SPWebItem -Url $SPWebItem.url -Member $PermissionItem.Member -PermissionMask $PermissionItem.PermissionMask -Type "Website"
        }
        
    }elseif ($IsUnique -ne “True”){}
    
    foreach ($SPlist in $SPWebItem.lists){
    
        $IsUnique = $SPlist.HasUniqueRoleAssignments
        if (($SPlist.permissions -ne $null) -and ($IsUnique -eq “True”)) {
        
            foreach ($PermissionItem in $SPlist.permissions){
                $SPListUrl = $SPSite.Url + $SPlist.ParentWebUrl + "/" + $SPlist.Title
                Write-Host "Item: $SPListUrl" -BackgroundColor Yellow -ForegroundColor Black
                $SPSecurableObjectPermissionReport += New-SPReportItem -Name $SPlist.Title -Url $SPListUrl -Member $PermissionItem.Member -PermissionMask $PermissionItem.PermissionMask -Type "List"
            }
        }elseif ($IsUnique -ne “True”) {}

    }
}

Write-Host ''; Write-Host “Finished” -BackgroundColor Green -ForegroundColor Black; Write-Host ''


if($OutPutToGridView){
    $SPSecurableObjectPermissionReport | Out-GridView
	Write-Host "`nFinished" -BackgroundColor Green -ForegroundColor Black
	Read-Host "`nPress Enter to exit"
}else{
    return $SPSecurableObjectPermissionReport
}