@echo off
setlocal enabledelayedexpansion

:: Define the base folder path
set "basePath=C:\Users\ryanpaul\IdeaProjects\DimensionClient\src\game"

:: Get base folder name
for %%A in ("%basePath%") do set "baseName=%%~nxA"

echo Base Folder Path: %basePath%
echo Base Folder Name: %baseName%
echo.

echo Listing files and folders:
echo ===========================

:: Loop through each item in the base folder
for /f "delims=" %%I in ('dir "%basePath%" /b /a') do (
    set "item=%basePath%\%%I"
    if exist "!item!\*" (
        echo Folder: %%I
        :: List files in this folder with indentation
        for /f "delims=" %%J in ('dir "!item!" /b /a-d') do (
            echo     └── %%J
        )
    ) else (
        echo File  : %%I
    )
)

echo ===========================
pause
