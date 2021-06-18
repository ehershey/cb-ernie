#package "geolessel/homebrew-repo/trello-cli" do
  #only_if { platform_family?("mac_os_x") }
#end
#
#include_recipe "nodejs"
#npm_package 'trello-cli' do
  #url "git@github.com:mheap/trello-cli.git"
#end
#
macos_desktop_screensaver do
  only_if { platform_family?("mac_os_x") }
end

# for gnucash
cpan_module 'Finance::Quote'

if platform_family?('mac_os_x') then
  short_hostname = node.name
  long_hostname = "#{short_hostname}.local"
  bash 'set hostname' do
    code <<-EOH
      scutil --set LocalHostName #{short_hostname}
      scutil --set HostName #{long_hostname}
      scutil --set ComputerName #{long_hostname}
      hostname #{long_hostname}
    EOH
  end
    hostname short_hostname do
      fqdn long_hostname
    end
    homebrew_cask "iterm2"
    homebrew_cask "chef-workstation"
    homebrew_package "hub"
    homebrew_package "oath-toolkit"
    homebrew_package "xmlstarlet"
    homebrew_package "moreutils"
    homebrew_package "mongodb/brew/mongodb-community"


end
