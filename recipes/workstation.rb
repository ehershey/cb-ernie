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
  include_recipe "ernie::macos"
 end
