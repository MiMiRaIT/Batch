@echo off
setlocal EnableDelayedExpansion
setlocal

set path=C:\Users\%username%\Desktop\backups\
if not exist %path% (
	mkdir %path%
	echo Create backup path
)
cd %path%

set CURRENT_TIME=%TIME%
set TIMESTAMP=%TIME::=.%

copy "K:\SYS19a\Modul 127\mimira\4Winde_MIMIRA_IT.docx" C:\Users\%username%\Desktop\backups\%DATE%.%TIMESTAMP%.4Winde_MIMIRA_IT.docx > NUL

for %%A in (*) do set /a cnt+=1
set count=%cnt%
echo files found: %cnt%

if "%count%" == "" (
	set count = 0
	echo Set Count to 0
)

if %count% >= 10 (
	forfiles -p %path% -s -m *.* /D -31 /C "cmd /c del @path"
)



