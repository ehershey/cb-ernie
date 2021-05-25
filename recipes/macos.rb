ENV['PATH'] = "#{Homebrew::prefix}/bin:" + ENV['PATH']

BREW_DAYS_MIN = 15

path = `which brew`
brew_installed = $?.success?

Chef::Log.info "brew_installed: #{brew_installed}"

Chef::Log.info "BREW_DAYS_MIN: #{BREW_DAYS_MIN}"
if brew_installed then
  brew_age_days = ( Time.now - File.mtime(path.strip) ) / 60 / 60 / 24
  Chef::Log.info "brew_age_days: #{brew_age_days}"
end

if ( !brew_installed ) || ( brew_age_days > BREW_DAYS_MIN ) then

  node.default['homebrew']['owner'] = node['ernie']['user']

  include_recipe "homebrew"

else
  Chef::Log.info "Skipping homebrew install because it's already installed"
end

  homebrew_cask "iterm2" do
    homebrew_path "#{Homebrew::prefix}bin/brew"
    not_if { (::File.exist? "/Applications/iTerm.app" ) || (::File.exist? "/Applications/New/iTerm.app" ) }
  end

  homebrew_cask "chef-workstation" do
    homebrew_path "#{Homebrew::prefix}bin/brew"
    not_if { ::File.exist? "/opt/chef-workstation/bin/uninstall_chef_workstation" }
  end

  homebrew_tap "mongodb/brew

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

