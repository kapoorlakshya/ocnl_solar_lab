$log_stamp = (get-content "C:\web_application\upload\last_log_line.log" | select -last 1).split(",")[0]
$now_time = Get-Date

Add-Content "C:\web_application\logs\fluke_upload_logs.log" "Uploaded Stamp $log_stamp at $now_time"

