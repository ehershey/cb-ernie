chef_gem 'chef-vault'

node.default['postfix']['aliases']['ernie'] = "ernie,ehershey+#{node['hostname']}@gmail.com"

if defined?(ChefVault) then
  vault = ChefVault::Item.load(cookbook_name, recipe_name)

  vault['relayhosts'].each do |relayhost,value|
    node.default['postfix']['sasl'][relayhost] = value
    node.default['postfix']['main']['relayhost'] = relayhost
  end
end

# mac-specifics
if platform_family?('mac_os_x') then
  node.default['postfix']['main']['mail_owner'] = "_postfix"
  node.default['postfix']['main']['setgid_group'] = "_postdrop"
  node.default['postfix']['main']["queue_directory"] = "/private/var/spool/postfix"
  node.default['postfix']['main']["daemon_directory"] = "/usr/libexec/postfix"
end
