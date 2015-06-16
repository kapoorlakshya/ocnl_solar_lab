for /f %%i in ('dir "C:\Fluke Hydra\Data\test_data\*.*" /b /od') do @IF NOT "%%i" == "data1.csv" set LAST=%%i

copy "C:\Fluke Hydra\Data\test_data\%LAST%" "C:\Fluke Hydra\Data\upload\"

timeout /t 2

"C:\Program Files\WinSCP\winscp.com" /script="C:\Fluke Hydra\Data\scripts\winscp-upload-script.txt"

timeout /t 10

echo Y | DEL "C:\Fluke Hydra\Data\upload\*.*"

