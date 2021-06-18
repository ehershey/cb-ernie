
name = recipe_name
logdir = "/var/log/#{name}"
stdoutlog = "#{logdir}/#{name}.log"
stderrlog = "#{logdir}/#{name}-err.log"


systemd_unit 'mongodb-grafana.service' do
  content({Unit: {
    Description: 'MongoDB Grafana Plugin',
    After: 'network.target',
  },
  Service: {
    Restart: 'on-failure',
    ExecStart: "sh -c \"npm run server --cache /tmp/grafana-npm --init-module /tmp/grafana-npm-init.js >> #{stdoutlog} 2>> #{stderrlog}\"",
    WorkingDirectory: '/var/lib/grafana/plugins/mongodb-grafana',
    User: 'grafana',
    Group: 'grafana',
    SyslogIdentifier: 'mongodb-grafana',
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

directory logdir do
  user 'grafana'
  group 'grafana'
  mode 0755
end

