@echo off
call config.bat
psql -f generator.sql --quiet
IF %ERRORLEVEL% == 0 (
    @echo on
    @echo .
    @echo     #########################################
    @echo     ### Classic Models Database Imported! ###
    @echo     #########################################

    @echo off
    @echo .
    @echo     SELECT first_name, last_name FROM employees LIMIT 5
    @echo .
    psql -d classic_models -c "SELECT first_name, last_name FROM employees LIMIT 5";
) ELSE (
    @echo .
    @echo     #####################################
    @echo     ### Classic Models Import FAILED! ###
    @echo     #####################################
    @echo .
)
PAUSE