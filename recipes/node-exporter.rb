if node['os'] == 'linux'
    include_recipe 'prometheus_exporters::node'
elsif node['os'] == 'darwin'
  package 'node_exporter'
  node_exporter_port = '9100'
	interface_name = node['prometheus_exporters']['listen_interface']
  interface = node['network']['interfaces'][interface_name]
  listen_ip = interface['addresses'].find do |_address, data|
    data['family'] == 'inet'
  end.first

	web_listen_address = "#{listen_ip}:#{node_exporter_port}"

  username = node['ernie']['user']
  Chef::Log.error("username: #{username}")
  uid = Etc.getpwnam(username).uid
  Chef::Log.error("uid: #{uid}")
  service_name = "gui/#{uid}/homebrew.mxcl.node_exporter"
  #service_name = "homebrew.mxcl.node_exporter"
  Chef::Log.error("service_name: #{service_name}")

  file "#{Homebrew::install_path}/etc/node_exporter.args" do
    content "--web.listen-address=#{web_listen_address}"
    notifies :restart, "service[#{service_name}]"
  end
  service service_name do
    action [:enable, :start]
    plist "/Users/#{username}/Library/LaunchAgents/homebrew.mxcl.node_exporter.plist"
  end
else
  Chef::Log.error("No node exporter install method for os: #{node['os']}")
end



