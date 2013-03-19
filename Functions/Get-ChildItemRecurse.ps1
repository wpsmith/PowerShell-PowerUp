﻿$Metadata = @{
	Title = "Get Child Item Recurse"
	Filename = "Get-ChildItemRecurse.ps1"
	Description = ""
	Tags = "powershell, function"
	Project = ""
	Author = "Janik von Rotz"
	AuthorEMail = "contact@janikvonrotz.ch"
	CreateDate = "2013-03-19"
	LastEditDate = "2013-03-19"
	Version = "1.0.0"
	License = @'
This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivs 3.0 Unported License.
To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/3.0/ or
send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.
'@
}
	
function Get-ChildItemRecurse{

<#
	.SYNOPSIS
		Return a list of of files

	.DESCRIPTION
		A detailed description of the function.

	.PARAMETER  Path
		Paht to cycle through.

	.PARAMETER  OnlyDirectories
		Switch parameter wether only to show directories

	.PARAMETER  Levels
		Scope levels.

	.EXAMPLE
		Get-ChildItemRecurse -Path C:\ -OnlyDirectories -Levels 3

	.INPUTS
		

	.OUTPUTS
		

	.NOTES
		

	.LINK
		
#>
	
	#--------------------------------------------------#
	# Parameter
	#--------------------------------------------------#
	param(
	    [parameter(Mandatory=$true)]
	    [String]
		$Path,
        [parameter(Mandatory=$false)]
        [int]
        $Levels = 0,
        [switch]
        $OnlyDirectories
	)

	#--------------------------------------------------#
	# Main
	#--------------------------------------------------#

    if($Host.Version.Major -lt 2){
        throw "Only compatible with Powershell version 2 and higher"
    }else{

        if($OnlyDirectories){
            $files = @(Get-ChildItem $Path -Force | Where {$_.PSIsContainer})
            $OnlyDirectories = $true
        }else{
            $files = @(Get-ChildItem $Path -Force)
            $OnlyDirectories = $false
        }


        foreach ($file in $files) {
            
            Write-Output $file

            if ($levels -gt 0 -and $file.PSIsContainer) {

                Get-ChildItemRecurse -Path $file.FullName -Levels ($levels - 1) -OnlyDirectories:$OnlyDirectories

            }
        }
    }
}