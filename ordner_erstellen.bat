@echo off

rem Ordner erstellen

echo Die Ordner werden erstellt....
echo Bitte einige Stunden warten....
d:
echo:
echo:

md public >nul
if %errorlevel%==0 (
	echo Public erfolgreich erstellt
) else (
	echo schief gelaufen....
)
echo:
echo:

md abt && cd abt && md kunden buchhaltung >nul
if %errorlevel%==0 (
	echo Verzeichnisse im abt erfolgreich erstellt
) else (
	echo Du hast scheisse gebaut!!)
)
echo:
echo:

md \room\kunden\ && cd \room\kunden\ && md saal suiten sizi bueros >nul
if %errorlevel%==0 (
	echo Verzeichnisse im kunden erfolgreich erstellt
) else (
	echo nicht schon wieder!!
)
echo:
echo:

md \user && cd \user && md benkra gerbae thokni stetra gerber dandse >nul
if %errorlevel%==0 (
	echo Verzeichnisse in user erfolgreich erstellt
) else (
	echo Jetzt reicht es langsam!
)
echo:
echo:

echo Script mehr oder weniger erfolgreich abgeschlossen....
echo:
echo:
echo byby
echo:

ping localhost -n 20 > nul