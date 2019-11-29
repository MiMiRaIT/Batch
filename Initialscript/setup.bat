rem DelayedExpansion muss eingeschalten sein, damit die Variablen während dem For-Loop verwendet werden können.
setlocal EnableDelayedExpansion
@echo off


REM  _   _______ _   _  _____ _____ ___   _   _ _____ _____ _   _ 
REM | | / /  _  | \ | |/  ___|_   _/ _ \ | \ | |_   _|  ___| \ | |
REM | |/ /| | | |  \| |\ `--.  | |/ /_\ \|  \| | | | | |__ |  \| |
REM |    \| | | | . ` | `--. \ | ||  _  || . ` | | | |  __|| . ` |
REM | |\  \ \_/ / |\  |/\__/ / | || | | || |\  | | | | |___| |\  |
REM \_| \_/\___/\_| \_/\____/  \_/\_| |_/\_| \_/ \_/ \____/\_| \_/
echo Setze Konstanten...
ping localhost -n 5 >NUL
set USER_CSV_PATH=C:\Users\%username%\Desktop\users.CSV
set GROUP_CSV_PATH=C:\Users\%username%\Desktop\groups.CSV
set FOLDER_CSV_PATH=C:\Users\%username%\Desktop\folders.CSV
set ROOT_PATH=D:\
set USER_HOMES=D:\users
set WORKSTATION_NAME=ws


REM  _____  _   _  _____ _____  _   __ _____ 
REM /  __ \| | | ||  ___/  __ \| | / //  ___|
REM | /  \/| |_| || |__ | /  \/| |/ / \ `--. 
REM | |    |  _  ||  __|| |    |    \  `--. \
REM | \__/\| | | || |___| \__/\| |\  \/\__/ /
REM  \____/\_| |_/\____/ \____/\_| \_/\____/

REM PRUEFE OB HOST SERVER ODER WORKSTATION IST
echo Pruefe Hostname...
ping localhost -n 5 >NUL
hostname > %TMP%\tmpfile.txt
set /p host_info= < %TMP%\tmpfile.txt
del %TMP%\tmpfile.txt
set host=%host_info:~0,2%
set server=1
if "%host%" == "%WORKSTATION_NAME%" (
	set server=0
	echo Workstation erkannt...
) else (
	echo Server erkannt...
)


echo Pruefe Konstanten...
ping localhost -n 5 >NUL
if not exist %USER_CSV_PATH% (
	color 47
	echo User-CSV nicht gefunden. Script wird beendet...
	echo Bitte Pfad im Script anpassen
	timeout 10
	exit
)

if not exist %GROUP_CSV_PATH% (
	color 47
	echo Gruppen-CSV nicht gefunden. Script wird beendet...
	echo Bitte Pfad im Script anpassen
	timeout 10
	exit
)

if not exist %FOLDER_CSV_PATH% (
	color 47
	echo Folder-CSV nicht gefunden. Script wird beendet...
	echo Bitte Pfad im Script anpassen
	timeout 10
	exit
)

if not exist %ROOT_PATH% (
	color 47
	echo Root-Pfad nicht gefunden. Script wird beendet...
	echo Bitte Pfad im Script anpassen
	timeout 10
	exit
)



REM  _____  _____  _   _     _____ _____ _   _  _      _____ _____ _____ _   _ 
REM /  __ \/  ___|| | | |   |  ___|_   _| \ | || |    |  ___/  ___|  ___| \ | |
REM | /  \/\ `--. | | | |   | |__   | | |  \| || |    | |__ \ `--.| |__ |  \| |
REM | |     `--. \| | | |   |  __|  | | | . ` || |    |  __| `--. \  __|| . ` |
REM | \__/\/\__/ /\ \_/ /   | |___ _| |_| |\  || |____| |___/\__/ / |___| |\  |
REM  \____/\____/  \___/    \____/ \___/\_| \_/\_____/\____/\____/\____/\_| \_/


rem BENUTZER ANLEGEN
set user_tmp=
echo Lege Benutzer an...
ping localhost -n 5 >NUL
for /F "tokens=1-3 delims=;" %%a in (%USER_CSV_PATH%) do (
	set uname=%%a
	echo --- !uname!
	set fullname=%%b
	set password=%%c
	net user !uname! !password! /Fullname:"!fullname!" /Expires:Never /add >NUL

	wmic useraccount WHERE Name='!uname!' set PasswordExpires=false >NUL
	wmic useraccount WHERE Name='!uname!' set PasswordChangeable=false >NUL
	if "!user_tmp!" == "" (
		set user_tmp=!uname!
	) else (
		set user_tmp=!user_tmp!;!uname!
	)
)



rem GRUPPEN ANLEGEN
echo Lege Gruppen an...
ping localhost -n 5 >NUL
for /F "tokens=1,2 delims=;" %%a in (%GROUP_CSV_PATH%) do (
	set group=%%a
	echo --- !group!
	set group_users=%%b
	net localgroup !group! /add >NUL
	call :addusers2group !group! !group_users!
)
goto :ordnerstruktur

rem BENUTZER ZU GRUPPEN HINZUFueGEN
echo Fuege Benutzer zu Gruppen hinzu...
ping localhost -n 5 >NUL
:addusers2group
set group=%~1
set users=%~2
for /F "tokens=1* delims=?" %%c in ("%users%") do (
	if not "%users%" == "" (
		set uname=%%c
		net localgroup %group% !uname! /add >NUL
		call :addusers2group %group% %%d
	)
)
goto :eof

REM   ___  ____  ____  _   _ _____ ____  ____ _____ ____  _   _ _  _______ _   _ ____  
REM  / _ \|  _ \|  _ \| \ | | ____|  _ \/ ___|_   _|  _ \| | | | |/ /_   _| | | |  _ \ 
REM | | | | |_) | | | |  \| |  _| | |_) \___ \ | | | |_) | | | | ' /  | | | | | | |_) |
REM | |_| |  _ <| |_| | |\  | |___|  _ < ___) || | |  _ <| |_| | . \  | | | |_| |  _ < 
REM  \___/|_| \_\____/|_| \_|_____|_| \_\____/ |_| |_| \_\\___/|_|\_\ |_|  \___/|_| \_\
:ordnerstruktur
if %server% == 1 (
	echo Erstelle Ordnerbaum...
	ping localhost -n 5 >NUL
	goto :serversetup
) else (
	goto :ENDOFSETUP
)

:serversetup
for /F "tokens=1-3 delims=;" %%a in (%FOLDER_CSV_PATH%) do (
	set folder=%%a
	set permissions=%%b
	set sharename=%%c
	
	mkdir %ROOT_PATH%!folder!
	icacls %ROOT_PATH%!folder! /inheritance:r >NUL
	icacls %ROOT_PATH%!folder! /grant system:f /grant administrators:f /grant "CREATOR OWNER":"(OI)(CI)(IO)m" >NUL
	if not "!sharename!" == "" (
		echo Freigabeordner: !sharename!
		net share !sharename!=%ROOT_PATH%!folder! /grant:everyone,change >NUL
	)
	call :addgroup2folder !folder! !permissions!
)
goto :userordner

rem GRUPPEN ZU ORDNER HINZUFUEGEN
:addgroup2folder
set folder=%~1
set permissions=%~2
for /F "tokens=1* delims=?" %%c in ("%permissions%") do (
	set permission=%%c
	if not "!permission!" == "" (
		icacls %ROOT_PATH%%folder% /grant !permission! >NUL
	)
	if not "%permissions%" == "" (
		call :addgroup2folder %folder% %%d
	)
)
goto :eof

REM  _   _ ____  _____ ____   ___  ____  ____  _   _ _____ ____  
REM | | | / ___|| ____|  _ \ / _ \|  _ \|  _ \| \ | | ____|  _ \ 
REM | | | \___ \|  _| | |_) | | | | |_) | | | |  \| |  _| | |_) |
REM | |_| |___) | |___|  _ <| |_| |  _ <| |_| | |\  | |___|  _ < 
REM  \___/|____/|_____|_| \_\\___/|_| \_\____/|_| \_|_____|_| \_\
:userordner
echo Lege Benutzerordner an...
ping localhost -n 5 >NUL
call :createuserdir "" "%user_tmp%"
goto :ENDOFSETUP


:createuserdir
set user=%~1
set users_list=%~2

if not "%user%" == "" (
	echo --- %user%
	mkdir %USER_HOMES%\%user% >NUL
	icacls %USER_HOMES%\%user% /grant %user%:f >NUL
	net share %user%$=%USER_HOMES%\%user% /grant:everyone,change >NUL
)

for /F "tokens=1* delims=;" %%a in ("%users_list%") do (
	set uname=%%a
	set restlist=%%b
	if not "%users_list%" == "" (
		call :createuserdir !uname! "!restlist!"
	)
)
goto :eof

:ENDOFSETUP
cls
echo.
echo.
echo.
echo.
echo =======SETUP ABGESCHLOSSEN=======
 
timeout 20
exit
