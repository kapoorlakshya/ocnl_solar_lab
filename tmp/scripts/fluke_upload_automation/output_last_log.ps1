"TIME, OFF, Irr-Py1, Irr-Py2, Irr-RC1, Temp-RC1, Irr-RC2, Temp-RC2, Flowrate, Temp-PV1, Temp-PV2, Temp-PV3, Temp-PV4, Temp-PV5, Temp-PV6, Temp-HXi, Temp-HXo, Temp-Amb, Temp-BBox, Temp-WTt, Temp-WTb, Unused, TOTAL, DIOAlarm" | Out-File -Encoding ASCII "C:\Fluke Hydra\Data\upload\last_log_line.log"
Get-Content "C:\Fluke Hydra\Data\test_data\data1.csv" | select -last 1 | Out-File -append -Encoding ASCII "C:\Fluke Hydra\Data\upload\last_log_line.log"