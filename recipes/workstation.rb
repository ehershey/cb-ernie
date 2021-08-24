# for gnucash
include_recipe 'perl'
cpan_module 'Finance::Quote'

if platform_family?('mac_os_x') then
  include_recipe "ernie::macos"
end

user = node['ernie']['user']
home = File.expand_path("~#{user}")

vimdir = "#{home}/.vim"

bundledir = "#{home}/.vim/bundle/Vundle.vim"

directory bundledir do
  owner user
  recursive true
end


execute "git clone VundleVim" do
    command "sudo -H -u #{user} git clone https://github.com/VundleVim/Vundle.vim.git #{bundledir}"
    not_if { ::File.exist? "#{bundledir}/.git" }
end
