Powershell.exe -executionpolicy remotesigned -File "C:\web_application\scripts\output_last_log.ps1"

timeout /t 1

"C:\Program Files (x86)\WinSCP\WinSCP.com" /script="C:\web_application\scripts\winscp-upload-script.txt"

timeout /t 1

Powershell.exe -executionpolicy remotesigned -File "C:\web_application\scripts\write_to_upload_log.ps1"

timeout /t 1

del "C:\web_application\upload\last_log_line.log"
