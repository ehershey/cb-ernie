#
# Cookbook:: ernie
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
#
#
#
if node['ernie']['packages'] && node['ernie']['packages'][node['platform_family']] then
  node['ernie']['packages'][node['platform_family']].each do |package|
    package package
  end
end

if node['ernie']['packages'] && node['ernie']['packages']['all'] then
  node['ernie']['packages']['all'].each do |package|
    package package
  end
end
