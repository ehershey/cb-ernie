def get_safe_local_addresses()
  return ['127.0.0.1']
  end
  if node['os'] == 'linux'
    include_recipe 'prometheus_exporters::node'
elsif node['os'] == 'darwin'
  package 'node_exporter'
  node_exporter_port = '9100'
  safe_local_addresses = get_safe_local_addresses()

  web_listen_addresses = ""
  safe_local_addresses.each do |listen_ip|
     Chef::Log.error("listen_ip: #{listen_ip}")
    web_listen_addresses = "#{web_listen_addresses} --web-listen-address=#{listen_ip}:#{node_exporter_port}"
  end

  username = node['ernie']['user']
  Chef::Log.error("username: #{username}")

  # doesn't seem to work 2023-04-07 - empty
  # listen_ip=`sudo -u #{username} /Applications/Tailscale.app/Contents/MacOS/Tailscale ip -4`

  # Chef::Log.error("listen_ip: #{listen_ip}")
  #
  #

  Chef::Log.error("safe_local_addresses: #{safe_local_addresses}")

  Chef::Log.error("web_listen_addresses: #{web_listen_addresses}")

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
    content "#{web_listen_addresses}"
    notifies :restart, "service[#{service_name}]"
  end
  service service_name do
    action [:enable, :start]
    plist "/Users/#{username}/Library/LaunchAgents/homebrew.mxcl.node_exporter.plist"
  end
else
  Chef::Log.error("No node exporter install method for os: #{node['os']}")
end



