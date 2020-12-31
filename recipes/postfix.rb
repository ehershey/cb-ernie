chef_gem 'chef-vault'

node.default['postfix']['aliases']['ernie'] = "ernie,ehershey+#{node['hostname']}@gmail.com"

vault = ChefVault::Item.load(cookbook_name, recipe_name)

vault['relayhosts'].each do |relayhost,value|
  node.default['postfix']['sasl'][relayhost] = value
  node.default['postfix']['main']['relayhost'] = relayhost
end

