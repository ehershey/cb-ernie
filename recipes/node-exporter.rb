if node['os'] == 'linux'
    include_recipe 'prometheus_exporters::node'
elsif node['os'] == 'darwin'
  package 'node_exporter'
  node_exporter_port = '9100'
	#interface_name = node['prometheus_exporters']['listen_interface']
  #interface = node['network']['interfaces'][interface_name]
  #listen_ip = interface['addresses'].find do |_address, data|
    #data['family'] == 'inet'
  #end.first

  username = node['ernie']['user']
  Chef::Log.error("username: #{username}")

  listen_ip=`sudo -u #{username} /Applications/Tailscale.app/Contents/MacOS/Tailscale ip -4`

  Chef::Log.error("listen_ip: #{listen_ip}")

	web_listen_address = "#{listen_ip}:#{node_exporter_port}"

  uid = Etc.getpwnam(username).uid
  Chef::Log.error("uid: #{uid}")
  service_name = "gui/#{uid}/homebrew.mxcl.node_exporter"
  #service_name = "homebrew.mxcl.node_exporter"
  Chef::Log.error("service_name: #{service_name}")

  execute "brew brew services start node_exporter" do
    user node['ernie']['user']
    not_if { ::File.exist? "/Users/ernie/Library/LaunchAgents/homebrew.mxcl.node_exporter.plist" }
  end

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



