#
# Cookbook Name:: rbenv
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# rubyのバージョンとglobal設定
rbenv_ruby '2.2.4'

# nginxのserviceを設定
service "nginx" do
  # chef-clientがserviceをどのように扱うかを設定
  supports :status => true, :restart => true, :reroad => true
  # serviceをboot出来るようにしておく
  action [:enable]
end
