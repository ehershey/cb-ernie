# mostly all based on
# https://github.com/chef-cookbooks/chef-client/blob/b8471185c868610a213022a686216a7fed192b91/attributes/normal.rb#L121
# Requires this be loaded BEFORE chef-client cookbook recipes since they assume this stuff is set already (maybe not)
#

# Configuration for chef-client::systemd_service recipe
normal['chef_client']['systemd']['timer'] = true

case node['platform_family']
when 'arch'
  normal['chef_client']['init_style']  = node['init_package']
  normal['chef_client']['run_path']    = '/var/run/chef'
  normal['chef_client']['cache_path']  = '/var/cache/chef'
  normal['chef_client']['backup_path'] = '/var/lib/chef'
  normal['chef_client']['chkconfig']['start_order'] = 98
  normal['chef_client']['chkconfig']['stop_order']  = 02

  normal['chef_client_updater']['version'] = '16.2.73'

  normal['ernie']['apple-mfi-fastcharge'] = true

end

