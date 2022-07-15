#powershell -command ".\comparacio.ps1 c:\temp\hola.txt c:\temp\hola2.txt"


param( [Parameter(Mandatory=$True,Position=1)][string]$Fitxer1,[Parameter(Mandatory=$True,Position=2)][string]$Fitxer2)

$dia1 = import-csv $Fitxer1 -Delimiter "#"  | sort -Property DirectoryPath
$dia2 = import-csv $Fitxer2 -Delimiter "#"  | sort -Property DirectoryPath

$Resultat = $dia1 | % { 
                foreach ($t2 in $dia2) {
                    if ($_.DirectoryPath -eq $t2.DirectoryPath) {
                        [pscustomobject]@{DirectoryPath=$_.DirectoryPath;nivell=$_.nivell;FileSize1=$_.FileSize;FileSize2=$t2.FileSize}
                    }
                }
				

            } 
			
			
$Resultat += foreach ($t2 in $dia2) {
				if ($dia1.DirectoryPath -notcontains  $t2.DirectoryPath) {
                        [pscustomobject]@{DirectoryPath=$t2.DirectoryPath;nivell=$t2.nivell;FileSize1=0;FileSize2=$t2.FileSize}
                    }
		}
		

		
		
		
$Resultat += foreach ($t1 in $dia1) {
				if ($dia2.DirectoryPath -notcontains  $t1.DirectoryPath) {
                        [pscustomobject]@{DirectoryPath=$t1.DirectoryPath;nivell=$t1.nivell;FileSize1=$t1.FileSize;FileSize2=0}
                    }
		}
		
		
		
		
		
$Resultat | ForEach-Object{
    $_ | Add-Member -MemberType NoteProperty -Name "diferencia" -Value ($_.FileSize2-$_.FileSize1) 
}		
$Resultat | ForEach-Object{
    $_ |  Add-Member -MemberType NoteProperty -Name "diferenciaMb" -Value $( [math]::round(($_.FileSize2-$_.FileSize1)/1MB,2))
}		
$Resultat | ForEach-Object{
    $_ |  Add-Member -MemberType NoteProperty -Name "diferenciaGb" -Value $( [math]::round(($_.FileSize2-$_.FileSize1)/1GB,2))
}




$Resultat = $Resultat | sort-object -property diferencia | where-object {$_.diferencia -ne '0'} 
 $Resultat | FT
$Resultat | export-csv -PATh c:\temp\diferencia.txt -Delimiter ';'
