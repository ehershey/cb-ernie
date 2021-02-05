systemd_unit 'mongodb-grafana.service' do
  content({Unit: {
    Description: 'MongoDB Grafana Plugin',
    After: 'network.target',
  },
  Service: {
    Type: 'notify',
    Restart: 'on-failure',
    ExecStart: 'npm run server --cache /tmp/grafana-npm --init-module /tmp/grafana-npm-init.js',
    WorkingDirectory: '/var/lib/grafana/plugins/mongodb-grafana',
    User: 'grafana',
    Group: 'grafana',
    SyslogIdentifier: 'grafana',
  },
  Install: {
    WantedBy: 'multi-user.target',
  }})
  action [:create, :enable]
end

directory '/var/lib/grafana/plugins/mongodb-grafana' do
  user 'grafana'
  group 'grafana'
  mode 0755
end
