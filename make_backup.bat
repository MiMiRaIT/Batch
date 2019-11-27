@echo off
setlocal EnableDelayedExpansion

rem Pfad für die Backups definieren
set path=C:\Users\%username%\Desktop\backups\
set filepath="K:\SYS19a\Modul 127\mimira\4Winde_MIMIRA_IT.docx"

rem Prüfen ob der Pfad bereits existiert, falls nicht, erstelle Ordner. 
if not exist %path% (
	mkdir %path%
	echo Create backup path
)

rem Wechsle den Pfad
cd %path%

rem Erstelle Timestamp (":" durch "." ersetzen)
set CURRENT_TIME=%TIME%
set TIMESTAMP=%TIME::=.%

rem Kopiere Datei in Backupordner
copy %filepath% %path%\%DATE%.%TIMESTAMP%.4Winde_MIMIRA_IT.docx > NUL

rem Zähle die Anzahl Dateien im Backup-Ordner
for %%A in (*) do set /a cnt+=1
set count=%cnt%
echo files found: %cnt%

rem Kann keine Zahl eruuiert werden, setze Counter auf 0
if "%count%" == "" (
	set count = 0
	echo Set Count to 0
)

rem Sind mehr als 10 Dateien vorhanden, lösche alle die älter als 31 Tage alt sind
if %count% >= 10 (
	forfiles -p %path% -s -m *.* /D -31 /C "cmd /c del @path"
)



