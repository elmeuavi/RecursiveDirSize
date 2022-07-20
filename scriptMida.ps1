<#
.SYNOPSIS
Script that will list folders sizes recursively.
.DESCRIPTION
** This script will list folders/files sizes recursively to a specified level.
** If the -Directory parameter is not specified or doesn't exist, the current directory is used. And -Level parameters will refer to child levels from that existing directory. 
.EXAMPLES USAGE:  
(inside powershell) .\scriptMida.ps1 -Directory c:\users -level 2 -Display -HiddeErrors
(inside cmd.exe or batch file) powershell -command ".\scriptMida.ps1 -Directory c:\users -level 2 -Display -HiddeErrors"
.PARAMETRES
**Display: Show output human view. If parameter not present, the output is with a column separator character #.
**HiddeErrors: Don't show error message when you can not enter into directory
#>

param( [Parameter(Mandatory=$False,Position=1)][string]$Directory,[int]$level,[switch]$display,[switch]$HiddeErrors)



function SumaRecursivaMida ($fullname){
	$retorn= "" | Select-Object DirectoryPath,FolderSize,'FolderSize(MB)','FolderSize(GB)'; 

		$size_sum = (Get-ChildItem -Force -R $fullname -File -EA SilentlyContinue -ErrorVariable ProcessError | Measure-Object -Property Length -Sum).sum
		$retorn.DirectoryPath=$fullname;
		$retorn.FolderSize=[decimal]"$( [math]::round($size_sum,2))" ; 
		$retorn.'FolderSize(MB)'=[decimal]"$( [math]::round($size_sum/1MB,2))" ; 
		$retorn.'FolderSize(GB)'=[decimal]"$( [math]::round($size_sum/1GB,2))" ; 
#			write-host $retorn.FolderSize $fullname

		If ($ProcessError -AND -NOT $HiddeErrors)
		{
			$ProcessError | ForEach-Object { write-host -fore red $_ | select-string 'is denied'}
		}	
		
		return $retorn
}



#########################################################################################
############## Function to retrieve directory with recursive function call #############
function Get-Directory ($fullname,$D_ChildLevel)  { 
#Write-Host $fullname $fullname.Split('\').Length $D_ChildLevel $level

	if ($local:fullname.ToLower() -like "c:\windows*" -or $local:fullname.ToLower() -like "c:\program*" ) {
		return
	}

	If($local:fullname.Split('\').Length -le $D_ChildLevel -OR !$level )
		{
			$local:size_sum = (Get-ChildItem -Force $local:fullname -File -EA SilentlyContinue -ErrorVariable ProcessError | Measure-Object -Property Length -Sum).sum


			[System.Collections.ArrayList]$local:Registres= @()
			#$local:Registres = @{}
			$local:obj= "" | Select-Object DirectoryPath,FolderSize,'FolderSize(MB)','FolderSize(GB)'; 
				
			$local:obj.DirectoryPath=$local:fullname; 
			

		############## Recall the function if the current directory is the directory itself ############33
			if ((Get-Item $local:fullname -Force) -is [system.io.directoryinfo] )
			{  
					$local:size_sum_tot = 0;
					Get-ChildItem -Force $local:fullname -directory -EA SilentlyContinue -ErrorVariable ChildProcess | ForEach-Object { 
						 $local:objectLocal = Get-Directory $_.fullname $D_ChildLevel
#						 write-host $local:objectLocal
						 	Foreach ($Element in $local:objectLocal){		
#								write-host $Element.FolderSize
								IF ($Element.FolderSize)
								{
									If($local:obj.DirectoryPath.Split('\').Length +1 -eq $Element.DirectoryPath.Split('\').Length){
										$local:size_sum_tot += $Element.FolderSize
									}

									$local:Registres += $Element
								}else {
									write-host "No hauria de passar mai per aquí !! Error"
								}
							}
					}
				
				
				$local:size_sum += $local:size_sum_tot 
				
				#write-host  "TOT" $local:size_sum $local:fullname		 			

				$local:obj.'FolderSize'=[decimal]"$( [math]::round($local:size_sum,2))" ; 
				$local:obj.'FolderSize(MB)'=[decimal]"$( [math]::round($local:size_sum/1MB,2))" ; 
				$local:obj.'FolderSize(GB)'=[decimal]"$( [math]::round($local:size_sum/1GB,2))" ; 
				
				if ($local:size_sum -ne 0){
					#$local:Registres[$local:Registres.Count]=$local:obj
					$local:Registres += $local:obj
				}else {
#					write-host "no hem guardat pq es zero" $local:fullname	
				}


				############## if the error variable is set, then output the error ###########
				If ($ProcessError -AND -NOT $HiddeErrors)
				{
					$ProcessError | ForEach-Object { write-host -fore red $_ | select-string 'is denied'}
				}	

				return $local:Registres 
			} 

	}
	else 
	{	
		$local:MidaSeguents = SumaRecursivaMida($local:fullname)
		 
		if ($local:MidaSeguents[0].FolderSize -ne "0" ) {
			#Write-Host "Últim element:"  $MidaSeguents[0]
			return $local:MidaSeguents 
		}else {
#					write-host "no hem guardat pq es zero" $local:fullname	
				}
	}
}







#####################################################################################################################################################################################
############### If the start directory is defined & if it exists then use the start directory & that directory's level, if not use the current directory & current level ############
If ($Directory -AND (Test-Path $Directory))
	{
############### If the user directory input is does not contain back slash such as c:, then put the back slash ###########
		If ($Directory -Notmatch '\\' -AND (Test-Path $Directory))
		{ $Directory  = $Directory+'\' }
############### If the directory input doesn't contains extra backslash such as c:\windows\, then increase $CurrentLevel value by one
		If ( ($Directory.Split('\') | Get-unique)[($Directory.Split('\') | Get-unique).Length-1].Length -eq 0 )
			{
			write-Debug "extra slash statement executed."
			$CurrentLevel = ($Directory.Split('\') | Get-unique).Length
			}
		else
			{
			write-Debug "WITHOUT extra slash statement executed."
			$CurrentLevel = $Directory.Split('\').Length + 1
			}
	}
else
	{
	#Write-Host -fore yellow "The specified directory does not exist. Using current directory as default starting directory."
		If ((Get-Location).Path.Split('\')[1].Length -eq 0)		## If the current directory is root Drive itself, then use the split length directly, if not, use length+1 for $CurrentLevel
			{
			$CurrentLevel = (Get-Location).Path.Split('\').Length
			}
		else
			{
			$CurrentLevel = (Get-Location).Path.Split('\').Length + 1
			}
	$Directory = Get-Location
	}
################ If $Level is not defined, then recurse through all directories ##########
If([int]$Level)
	{
	$TotalChildLevel = $CurrentLevel + $Level - 2			## add current level + child level, so that we can check fullpath and ignore if path is longer than defined in functions.
	}
	
	
	Clear-Variable DiccionariArray -EA SilentlyContinue
	[System.Collections.ArrayList]$DiccionariArray= @()
	
	$dia = Get-Date -Format "yyyy/MM/dd HH:mm"
	
	
	Get-ChildItem -Force $Directory -directory | ForEach-Object { 
		$DiccionariArray += Get-Directory $_.fullname $TotalChildLevel 
	}    


	If ($display){
			$DiccionariArray | Format-Table
	}else {
		write-host "Temps#nivell#DirectoryPath#FileSize#FileSize(MB)#FileSize(GB)"
		Foreach ($Element in $DiccionariArray){
			#write-host  $Element.DirectoryPath $Element 
			$linia = $dia +'#'+ ($Element.DirectoryPath.Split('\').Length -1) +'#'+ $Element.DirectoryPath +'#'+ $Element.FolderSize +'#'+ $Element.'FolderSize(MB)' +'#'+ $Element.'FolderSize(GB)' 
			 write-host $linia 
		}

			
		
	}
	