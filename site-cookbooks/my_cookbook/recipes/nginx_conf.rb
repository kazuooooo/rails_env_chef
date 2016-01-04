nginx_site 'default' do
  enable false
end

template "#{node["nginx"]["dir"]}/sites-available/site_practice" do
  source "nginx.conf.erb"
  mode 0644
  owner "vagrant"
  group "root"
  notifies :restart, 'service[nginx]'
end

nginx_site "site_practice"
