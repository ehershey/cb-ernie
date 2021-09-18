
# not used by everything
appdir = "/Applications/New"


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

homebrew_cask "plex-media-server" do
  homebrew_path "#{Homebrew::prefix}bin/brew"
  options "--appdir=#{appdir}"
  not_if { (::File.exist? "/Applications/Plex Media Server.app" ) || (::File.exist? "#{appdir}/Plex Media Server.app" ) }
end

homebrew_cask "vlc" do
  homebrew_path "#{Homebrew::prefix}bin/brew"
  options "--appdir=#{appdir}"
  not_if { (::File.exist? "/Applications/VLC.app" ) || (::File.exist? "#{appdir}/VLC.app" ) }
end



homebrew_cask "iterm2" do
  homebrew_path "#{Homebrew::prefix}bin/brew"
  options "--appdir=#{appdir}"
  not_if { (::File.exist? "/Applications/iTerm.app" ) || (::File.exist? "#{appdir}/iTerm.app" ) }
end


homebrew_cask "zoom" do
  homebrew_path "#{Homebrew::prefix}bin/brew"
  options "--appdir=#{appdir}"
  not_if { (::File.exist? "/Applications/zoom.us.app" ) || (::File.exist? "#{appdir}/zoom.us.app" ) }
end



homebrew_cask "chef-workstation" do
  homebrew_path "#{Homebrew::prefix}bin/brew"
  not_if { ::File.exist? "/opt/chef-workstation/bin/uninstall_chef_workstation" }
end

homebrew_cask "xbar.app" do
  homebrew_path "#{Homebrew::prefix}bin/brew"
  options "--appdir=#{appdir}"
  not_if { (::File.exist? "/Applications/xbar.app" ) || (::File.exist? "#{appdir}/xbar.app" ) }
end

homebrew_tap "mongodb/brew" do
  homebrew_path "#{Homebrew::prefix}bin/brew"
end

homebrew_tap "rodionovd/taps" do
  homebrew_path "#{Homebrew::prefix}bin/brew"
end


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
file "/etc/sudoers.d/chef-brew" do
  content <<-FOO
  # for chef to install homebrew casks
  # e.g. /usr/bin/sudo -E -- /usr/bin/env LOGNAME=ernie USER=ernie USERNAME=ernie /usr/sbin/installer -pkg /opt/homebrew/Caskroom/chef-workstation/21.6.467/chef-workstation-21.6.467-1.x86_64.pkg -target /
  ernie ALL = (ALL) NOPASSWD:SETENV: /usr/bin/env
  FOO
  owner 'root'
  group 'wheel'
  mode '0644'
end


%w{vim ctags}.each do|package|
  execute "brew unlink #{package}" do
    user node['ernie']['user']
    only_if { ::Dir.exist? "#{Homebrew::prefix}/Cellar/#{package}" }
  end
end

