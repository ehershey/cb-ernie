# for gnucash
cpan_module 'Finance::Quote'

if platform_family?('mac_os_x') then
  include_recipe "ernie::macos"
end
