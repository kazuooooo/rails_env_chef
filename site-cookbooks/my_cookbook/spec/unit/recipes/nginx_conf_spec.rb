require_relative '../spec_helper'

describe 'my_cookbook::nginx_conf' do
  let(:chef_run) do

    stub_command('which nginx').and_return('/usr/local/bin/nginx')

    ChefSpec::SoloRunner.new do |node|
      node.set['nginx']['dir'] = '/etc/nginx'
    end.converge(described_recipe)
  end

  it 'create /etc/nginx/sites-available/site_practice' do
    expect(chef_run).to create_template('/etc/nginx/sites-available/site_practice')
  end

end
