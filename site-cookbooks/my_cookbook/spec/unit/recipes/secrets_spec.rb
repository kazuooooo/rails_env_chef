require_relative '../spec_helper'

describe 'my_cookbook::secrets' do
  before do
    allow(Chef::EncryptedDataBagItem).to receive(:load).with('foo', 'bar').and_return({
      id: 'bar',
      naisyo_value: 'test_naisyo_value'
    })
  end
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'create /etc/profile.d/secrets.sh' do
    expect(chef_run).to create_template('/etc/profile.d/secrets.sh')
  end

  it 'get naisyo value' do
    data_bag = Chef::EncryptedDataBagItem.load('foo','bar')
    naisyo_value = data_bag[:naisyo_value]
    expect(naisyo_value).to eq('test_naisyo_value')
  end

  it 'load secrets.sh' do
    expect(chef_run).to run_bash('load secrets.sh')
  end

end
