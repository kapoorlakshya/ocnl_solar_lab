# OCNL SOLAR LAB

This is an online dashboard for the solar panels on the 4th floor of OCN maintained by the Mechanical Engineering department of California State University, ChicoL. This application tracks sensor data by the minute and daily power data updated at midnight.

### How it works

This is a 2-part system with one part being the data acqisition end and the other being the data presentation end. The data acquistion consists of two separate systems feeding the sensor and power data. Fluke Hydra Data Logger (sensors) data reports various temperature levels and the Azuray ACM300 reports power data.

## Features

* Minute-by-minute sensor updates from the Fluke Hydra Data Logger with autorefresh set for 60 seconds

* Daily updates on power output at midnight from ACM300

* Search enabled graphs to plot DC Power Output by Module, Total DC power Output, Module Temperature vs Time of Day, Solar Irradiance, and Battery Box Temperature.

* Search for raw data by day and time.

* Download raw or transposed data in CSV to import in to Excel.

* Date Tracker which tracks and reports any missing data for a day or a period of days. Based on the fact that there should be at least 24 Hours * 60 Minutes = 1440 Logs each day.

* Gallery with images of the solar array

* About page

* Simple login system to limit searching, graphing, and downloading (Sorcery Gem)


## Dependencies

#### Data Acquistion

* Wndows 7 x64

* Fluke Hydra Data Logger

* WinSCP.com (part of WinSCP package)

* System Scheduler (Freeware, more options than Windows Task Scheduler)

* Internet Access / Local access for university network based setup

* Configure ACM300 to send nightly reports over a ftp account.

All the above are made available on the Dell PC under "C:\web_application\ocnl_solar_lab_data_acquistion_set.zip" which includes a README. Except for Windows 7 of course.

#### Presentation (Dashboard)

* LAMP stack

* Ruby version 2.2.1p85

* Rails 4.2.0

* mySQL

* phpmyadmin

* Bundler

* Apache 2.4.x with Passsenger

### How to run the test suite

Please email me and I would be happy to either provide a dataset or fire up a node on AWS to demo the app. The app is purposely designed around a pre-populated schema.