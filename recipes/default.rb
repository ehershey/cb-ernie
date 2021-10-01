#
# Cookbook:: ernie
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
#
#
#
if node['ernie']['packages'] && node['ernie']['packages'][node['platform_family']]
  node['ernie']['packages'][node['platform_family']].each do |package|
    package package
  end
end

if node['ernie']['packages'] && node['ernie']['packages']['all']
  node['ernie']['packages']['all'].each do |package|
    package package
  end
end

user = node['ernie']['user']
gopath = node['ernie']['gopath'][node['os']]

directory gopath do
  owner user
  recursive true
end

if node['ernie']['go_packages']
  node['ernie']['go_packages'].each do |package|
    execute "go-get-#{package}" do
      command "go get #{package}"
      user user
      environment({
        GOPATH: "#{gopath}",
        GOCACHE: '/tmp',
      })
      # # Use the package-installed Go as the bootstrap version b/c Go is built with Go
      # GOROOT_BOOTSTRAP: "#{new_resource.install_dir}/go-#{new_resource.version}",
      # GOROOT: "#{new_resource.install_dir}/go",
      # GOBIN: "#{new_resource.install_dir}/go/bin",
      # })
      # not_if "test -x #{::File.join(new_resource.install_dir, 'go', 'bin', 'go')}  && #{::File.join(new_resource.install_dir, 'go', 'bin', 'go')}  version | grep #{new_resource.source_version}"
      # not_if { ::File.exist? "/opt/chef-workstation/bin/uninstall_chef_workstation" }
    end
  end
end


