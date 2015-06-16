json.array!(@flukes) do |fluke|
  json.extract! fluke, :id, :log_time, :off, :irr_py1, :irr_py2, :irr_rc1, :temp_rc1, :irr_rc2, :temp_rc2, :flowrate, :temp_pv1, :temp_pv2, :temp_pv3, :temp_pv4, :temp_pv5, :temp_pv6, :temp_hxi, :temp_hxo, :temp_amb, :temp_bbox, :temp_wtt, :temp_wtb, :tempC, :total, :dioalarm
  json.url fluke_url(fluke, format: :json)
end
