#
# Cookbook Name:: rbenv
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# 必要なパッケージのインストール
# http://docs.getchef.com/resource_package.html
%w{git gcc openssl-devel readline-devel nginx}.each do |pkg|
  package pkg do
    action :install
  end
end

# --------------------------------------------------------
# install ruby by rbenv
# --------------------------------------------------------
# rbenvのダウンロード
# http://docs.getchef.com/resource_git.html
git "/usr/local/rbenv" do
  repository "https://github.com/sstephenson/rbenv.git"
  revision "master"
  action :sync
end

# プラグインディレクトリの作成
# http://docs.getchef.com/resource_directory.html
directory "/usr/local/rbenv/plugins" do
  action :create
end

# ruby-buildプラグインのダウンロード
git "/usr/local/rbenv/plugins/ruby-build" do
  repository "https://github.com/sstephenson/ruby-build.git"
  revision "master"
  action :sync
end

# bashの環境設定を行うシェルスクリプトの設置 (先程作成したテンプレートファイルを利用)
# http://docs.getchef.com/resource_template.html
template "/etc/profile.d/rbenv.sh" do
  source "rbenv.sh.erb"
  action :create
end

# rubyのインストール
# http://docs.getchef.com/resource_bash.html
bash "install-ruby-with-rbenv" do
  # code "" の中身が実行
  code "source /etc/profile.d/rbenv.sh && rbenv install 2.2.2 && rbenv rehash"
  action :run
  not_if { File.exists?('/usr/local/rbenv/versions/2.2.2') }
end

# bundlerのインストール
bash "install-bundler" do
  code "source /etc/profile.d/rbenv.sh && rbenv global 2.2.2 && rbenv exec gem install bundler && rbenv rehash"
  action :run
end

# --------------------------------------------------------
# nginx
# --------------------------------------------------------
service "nginx" do
  # nginx がサポートしている機能を教えてあげます。
  # restartとかできるよーという意味らしい。
  supports status: true, restart: true, reload: true

  # サーバーを有効にした上で、スタートします。
  # 有効にしておけばマシン再起動時にも勝手にサーバーが起動します。
  action [:enable, :start]
end
# ./site_cookbooks/templates/default/nginx.conf.erbを元にして
# nginxの設定ファイルを決まったところに置くよという指示
# Chefの規約にのおかげで置き場所のパスやテンプレートファイルは省略できている
template "nginx.conf" do
  # ownerとgroupはrootユーザーでパーミッションは644
  owner "root"
  group "root"
  mode 0644

  # この動作のあとでnginxを再起動してねという指示
  notifies :reload, "service[nginx]"
end

