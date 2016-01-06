require_relative '../spec_helper'

describe 'my_cookbook::create_user' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'create user' do
    expect(chef_run).to create_user('kazuya')
  end

end
