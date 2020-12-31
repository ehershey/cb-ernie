chef_gem chef-vault

default['postfix']['aliases']['ernie'] = "ernie,ehershey+#{node['hostname']}@gmail.com"

vault = ChefVault::Item.load(cookbook_name, recipe_name)

vault['relayhosts'].each do |relayhost,value|
  default['postfix']['sasl'][relayhost] = value
  default['postfix']['main']['relayhost'] = relayhost
end

