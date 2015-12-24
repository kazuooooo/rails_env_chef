# secrets.shを作成
template "/etc/profile.d/secrets.sh" do
  source "secrets.sh.erb"
  action :create
end

# 値を飛ばす
data_bag = Chef::EncryptedDataBagItem.load('foo','bar')
naisyo_value = data_bag['naisyo_value']
template "/etc/profile.d/secrets.sh" do
  variables ({
              :naisyo => naisyo_value
            })
end

# secrets.shを読み込み
bash "load secrets.sh" do
  code "source /etc/profile.d/secrets.sh"
  action :run
end
