  apache_exporter_port = "9117"
	interface_name = node['prometheus_exporters']['listen_interface']
  interface = node['network']['interfaces'][interface_name]
  listen_ip = interface['addresses'].find do |_address, data|
    data['family'] == 'inet'
  end.first

apache_exporter 'main' do
	telemetry_address "#{listen_ip}:#{apache_exporter_port}"
	user "nobody"
end
