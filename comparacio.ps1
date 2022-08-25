#powershell -command ".\comparacio.ps1 c:\temp\hola.txt c:\temp\hola2.txt"


param( [Parameter(Mandatory=$True,Position=1)][string]$Fitxer1,[Parameter(Mandatory=$True,Position=2)][string]$Fitxer2)

$i1=0
$i2=0
$Resultat = @()


$dia1 = import-csv $Fitxer1 -Delimiter ";"  | sort -Property DirectoryPath
$max1 = $dia1.count
write-host  "Directoris al fitxer 1 "  $max1

$dia2 = import-csv $Fitxer2 -Delimiter ";"  | sort -Property DirectoryPath
$max2 = $dia2.count
write-host  "Directoris al fitxer 2 "  $max2


while (($max1 -gt $i1) -and ($max2 -gt $i2)){
    if ($dia1[$i1].DirectoryPath -eq $dia2[$i2].DirectoryPath) {
        if ($dia1[$i1].FileSize -ne $dia2[$i2].FileSize) {
            $Resultat += [pscustomobject]@{DirectoryPath=$dia1[$i1].DirectoryPath;nivell=$dia1[$i1].nivell;FileSize1=$dia1[$i1].FileSize;FileSize2=$dia2[$i2].FileSize}
        }
	    $i1 +=1
        $i2 +=1
    }
    if ($dia1[$i1].DirectoryPath -gt $dia2[$i2].DirectoryPath) {
        $Resultat += [pscustomobject]@{DirectoryPath=$dia2[$i2].DirectoryPath;nivell=$dia2[$i2].nivell;FileSize1=0;FileSize2=$dia2[$i2].FileSize}
        $i2 +=1
    }
    if ($dia1[$i1].DirectoryPath -lt $dia2[$i2].DirectoryPath) {
        $Resultat += [pscustomobject]@{DirectoryPath=$dia1[$i1].DirectoryPath;nivell=$dia1[$i1].nivell;FileSize1=$dia1[$i1].FileSize;FileSize2=0}
	    $i1 +=1
    }
}

while ($max1 -gt $i1){
    $Resultat += [pscustomobject]@{DirectoryPath=$dia1[$i1].DirectoryPath;nivell=$dia1[$i1].nivell;FileSize1=$dia1[$i1].FileSize;FileSize2=0}
    $i1 +=1
}
while ($max2 -gt $i2){
    $Resultat += [pscustomobject]@{DirectoryPath=$dia2[$i2].DirectoryPath;nivell=$dia2[$i2].nivell;FileSize1=0;FileSize2=$dia2[$i2].FileSize}
    $i2 +=1
}

		

		
		
$Resultat | ForEach-Object{
   # write-host $_.FileSize2 $_.FileSize1 $_.DirectoryPath
    $_ | Add-Member -MemberType NoteProperty -Name "diferencia" -Value ($_.FileSize2-$_.FileSize1) 
}		
$Resultat | ForEach-Object{
    #write-host $_.FileSize2 $_.FileSize1 $_.DirectoryPath
    $_ |  Add-Member -MemberType NoteProperty -Name "diferenciaMb" -Value $( [math]::round(($_.FileSize2-$_.FileSize1)/1MB,2))
}		
$Resultat | ForEach-Object{
    #write-host $_.FileSize2 $_.FileSize1 $_.DirectoryPath
    $_ |  Add-Member -MemberType NoteProperty -Name "diferenciaGb" -Value $( [math]::round(($_.FileSize2-$_.FileSize1)/1GB,2))
}



$Resultat = $Resultat | sort-object -property diferencia | where-object {$_.diferencia -ne '0'} 
$Resultat | FT

$Resultat | export-csv "ResultatComparacio.csv" -Delimiter ";"
