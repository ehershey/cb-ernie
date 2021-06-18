
if platform_family?("mac_os_x") then
  template_group = 'wheel'
  log_group = 'wheel'
else
  template_group = 'root'
  log_group = node['ernie']['user']
end

logrotate_app 'erniepayloads' do
  path '/var/log/erniepayloads/*.log'
  frequency 'daily'
  rotate 30
  options   ['delaycompress', 'notifempty', 'dateext', 'missingok']
  olddir 'archived_logs'
  create    "644 #{node['ernie']['user']} #{node['ernie']['user']}"
  template_group template_group
end
directory "/var/log/erniepayloads/archived_logs" do
  user node['ernie']['user']
  group log_group
  recursive true
end
