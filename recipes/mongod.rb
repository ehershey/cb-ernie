  mongod_exporter_port = "9216"
	interface_name = node['prometheus_exporters']['listen_interface']
  interface = node['network']['interfaces'][interface_name]
  listen_ip = interface['addresses'].find do |_address, data|
    data['family'] == 'inet'
  end.first

mongod_exporter 'main' do
	web_listen_address "#{listen_ip}:#{mongod_exporter_port}"
	user "nobody"
  collect_collection true
  collect_connpoolstats true
  collect_database true
  collect_indexusage true
  collect_topmetrics true
end
