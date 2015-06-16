Powershell.exe -executionpolicy remotesigned -File "C:\Fluke Hydra\Data\scripts\output_last_log.ps1"

timeout /t 1

"C:\Program Files\WinSCP\winscp.com" /script="C:\Fluke Hydra\Data\scripts\winscp-upload-script.txt"

Powershell.exe -executionpolicy remotesigned -File "C:\Fluke Hydra\Data\scripts\write_to_upload_log.ps1"

timeout /t 1

del "C:\Fluke Hydra\Data\upload\last_log_line.txt"
