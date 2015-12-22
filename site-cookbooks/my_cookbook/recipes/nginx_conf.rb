# nginxのserviceを設定
service "nginx" do
  # chef-clientがserviceをどのように扱うかを設定
  supports :status => true, :restart => true, :reroad => true
  # serviceをboot出来るようにしておく
  action [:enable]
end

# nginxのテンプレートファイルを配置
template "nginx.conf" do
  path "/etc/nginx/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :reload, 'service[nginx]'
end
