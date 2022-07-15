Two diferent scripts working together:


ScriptMida.ps1
------------------
Script that will list folders sizes recursively.

Examples:

powershell -command ".\scriptMida.ps1 -Directory c:\hp -level 2 -HiddeErrors -Display"

DirectoryPath                 FolderSize FolderSize(MB) FolderSize(GB)
-------------                 ---------- -------------- --------------
C:\hp\BIN                         347095           0,33              0
C:\hp\bridge                        2460              0              0
C:\hp\HPQWare\bridge                2460              0              0
C:\hp\HPQWare\browser              78553           0,07              0
C:\hp\HPQWare\BTBHost             715797           0,68              0
C:\hp\HPQWare\Favs                  6098           0,01              0
C:\hp\HPQWare\Netflix                 76              0              0
C:\hp\HPQWare\Simplesolitaire          6              0              0
C:\hp\HPQWare                     803076           0,77              0
C:\hp\McAfeeRules                   8014           0,01              0
C:\hp\support\flexroot            152866           0,15              0
C:\hp\support                     320415           0,31              0


C:\Users\xbrun>powershell -command ".\scriptMida.ps1 -Directory c:\hp -level 2 -HiddeErrors"
Temps#nivell#DirectoryPath#FileSize#FileSize(MB)#FileSize(GB)
2022/07/16 01:21#2#C:\hp\BIN#347095#0.33#0
2022/07/16 01:21#2#C:\hp\bridge#2460#0#0
2022/07/16 01:21#3#C:\hp\HPQWare\bridge#2460#0#0
2022/07/16 01:21#3#C:\hp\HPQWare\browser#78553#0.07#0
2022/07/16 01:21#3#C:\hp\HPQWare\BTBHost#715797#0.68#0
2022/07/16 01:21#3#C:\hp\HPQWare\Favs#6098#0.01#0
2022/07/16 01:21#3#C:\hp\HPQWare\Netflix#76#0#0
2022/07/16 01:21#3#C:\hp\HPQWare\Simplesolitaire#6#0#0
2022/07/16 01:21#2#C:\hp\HPQWare#803076#0.77#0.00
2022/07/16 01:21#2#C:\hp\McAfeeRules#8014#0.01#0
2022/07/16 01:21#3#C:\hp\support\flexroot#152866#0.15#0
2022/07/16 01:21#2#C:\hp\support#320415#0.31#0.00



Comparacio.ps1
-----------------
By executing several times the ScriptMida.ps1 mentioned before (over the same directory and without -Display option), you can compare two results. 
This script show only the diferences bettween the input files:
powershell -command ".\comparacio.ps1 c:\temp\hola2.txt c:\temp\hola20220716.txt"

DirectoryPath                             nivell FileSize1   FileSize2   diferencia diferenciaMb diferenciaGb
-------------                             ------ ---------   ---------   ---------- ------------ ------------
C:\Users\Smith\AppData\Roaming            4      1978597921  1978558661      -39260        -0,04            0
C:\Users\Smith\Documents\Projecte         4      13864552    13864625            73            0            0
C:\Users\Smith\Documents                  3      93665010498 93665041858      31360         0,03            0
C:\Users\Smith\AppData\LocalLow           4      39690806    39913741        222935         0,21            0
C:\Users\Smith\Downloads                  3      69995035658 70021799243   26763585        25,52         0,02
C:\Users\Smith\AppData\Local              4      16470515348 16551865856   81350508        77,58         0,08
C:\Users\Smith\AppData                    3      18488804075 18570338258   81534183        77,76         0,08


