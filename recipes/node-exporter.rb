username = node['ernie']['user']

group "node_exporter" do
  action :create
  append true
  members [ username ]
end

directory node['prometheus_exporters']['node']['textfile_directory'] do
  mode 0775
  recursive true
  user root
  group "node_exporter"
end


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

  Chef::Log.error("username: #{username}")

  # doesn't seem to work 2023-04-07 - empty
  # listen_ip=`sudo -u #{username} /Applications/Tailscale.app/Contents/MacOS/Tailscale ip -4`

  Chef::Log.error("listen_ip: #{listen_ip}")

	web_listen_address = "#{listen_ip}:#{node_exporter_port}"

  uid = Etc.getpwnam(username).uid
  Chef::Log.error("uid: #{uid}")

  user_home = Etc.getpwnam(username).dir
  Chef::Log.error("user_home: #{user_home}")

  service_name = "gui/#{uid}/homebrew.mxcl.node_exporter"
  #service_name = "homebrew.mxcl.node_exporter"
  Chef::Log.error("service_name: #{service_name}")

  ENV['PATH'] = "#{Homebrew::install_path}/bin:" + ENV['PATH']
  Chef::Log.error "ENV['PATH']: #{ENV['PATH']}"

  execute "brew services start node_exporter" do
    user node['ernie']['user']
    creates "#{user_home}/Library/LaunchAgents/homebrew.mxcl.node_exporter.plist"
    environment ({'HOME' => user_home})
  end

  file "#{Homebrew::install_path}/etc/node_exporter.args" do
    content "--web.listen-address=#{web_listen_address}"
    notifies :restart, "service[#{service_name}]"
  end
  service service_name do
    action [:enable, :start]
    plist "/Users/#{username}/Library/LaunchAgents/homebrew.mxcl.node_exporter.plist"
    only_if { listen_ip != '' }
  end
  service service_name do
    action [:disable]
    plist "/Users/#{username}/Library/LaunchAgents/homebrew.mxcl.node_exporter.plist"
    only_if { listen_ip == '' }
  end
else
  Chef::Log.error("No node exporter install method for os: #{node['os']}")
end


