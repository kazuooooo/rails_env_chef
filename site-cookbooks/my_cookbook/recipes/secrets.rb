# secrets.shを作成
template "/etc/profile.d/secrets.sh" do
  source "secrets.sh.erb"
  action :create
end

# secrets.shを読み込み
bash "load secrets.sh" do
  code "source /etc/profile.d/secrets.sh"
  action :run
end
