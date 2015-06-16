json.array!(@acm300_logs) do |acm300_log|
  json.extract! acm300_log, :id, :acm_module, :log_date, :log_time, :vin, :iin, :vout, :iout, :power
  json.url acm300_log_url(acm300_log, format: :json)
end
