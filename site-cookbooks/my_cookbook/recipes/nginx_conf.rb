template "#{node["nginx"]["dir"]}/sites-available/conf" do
  source "nginx.conf.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :reload, 'service[nginx]'
end

nginx_site "conf"
