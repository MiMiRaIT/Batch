@echo off

rem Praktikant
net user nicber Zli.1234 /add /fullname:"Nico Berger"
rem Abteilungsleiter
net user gerbae Zli.1234 /add /fullname:"Gerhard Bär"
rem Front Desk
net user danber Zli.1234 /add /fullname:"Daniela Bertolini"

rem Gruppen
net localgroup geschäftsleitung /add
net localgroup administration /add
net localgroup front-office /add
net localgroup back-office /add
net localgroup food und beverage /add
net localgroup convention /add
net localgroup housekeeping /add
net localgroup technik /add

rem Bnutzer zu Gruppen
net localgroup front-office nicber /add
net localgroup front-office gerbae /add
net localgroup back-office gerbae /add
net localgroup front-office danber /add
