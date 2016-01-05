require 'pry'
require_relative '../spec_helper'

describe 'my_cookbook::secrets' do

  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it "create /etc/profile.d/secrets.sh" do
    expect(chef_run).to create_template("/etc/profile.d/secrets.sh")
  end

  it "get naisyo value" do
    allow(Chef::EncryptedDataBagItem).to receive(:load).with('foo', 'bar').and_return({
      id: "bar",
      naisyo_value: "test_naisyo_value"
    })
    data_bag = Chef::EncryptedDataBagItem.load('foo','bar')
    naisyo_value = data_bag[:naisyo_value]
    expect(naisyo_value).to eq("test_naisyo_value")
  end

  # it "load secrets.sh by bash" do
  #   expect(chef_run).to run_bash("source /etc/profile.d/secrets.sh")
  # end

end

# # secrets.shを作成
# template "/etc/profile.d/secrets.sh" do
#   source "secrets.sh.erb"
#   action :create
# end

# # 値を飛ばす
# data_bag = Chef::EncryptedDataBagItem.load('foo','bar')
# naisyo_value = data_bag['naisyo_value']
# template "/etc/profile.d/secrets.sh" do
#   variables ({
#               :naisyo => naisyo_value
#             })
# end

# # secrets.shを読み込み
# bash "load secrets.sh" do
#   code "source /etc/profile.d/secrets.sh"
#   action :run
# end
