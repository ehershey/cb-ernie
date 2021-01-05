logrotate_app 'erniepayloads'
  path '/var/log/erniepayloads/*.log'
  frequency 'daily'
  rotate 30
  options   ['delaycompress', 'notifempty', 'dateext']
  olddir 'archived_logs'
  create    "644 #{node['ernie']['user']} #{node['ernie']['user']}"
done

