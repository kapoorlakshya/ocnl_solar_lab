$log_stamp = (get-content "C:\Fluke Hydra\Data\upload\last_log_line.log" | select -last 1).split(",")[0]
$now_time = Get-Date

Add-Content "C:\Fluke Hydra\Data\logs\fluke_upload_logs.log" "Uploaded Stamp $log_stamp at $now_time"

