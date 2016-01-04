require_relative '../spec_helper'
require 'chefspec'

describe 'my_cookbook::nginx_conf' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set["nginx"]["port"] = "8080"
    end.converge(described_recipe)
  end

  it "create /etc/nginx/sites-available/site_practice" do
    expect(chef_run).to create_template("/etc/nginx/sites-available/site_practice")
  end

  it "changes port to 8080 in /etc/nginx/sites-available/site_practice" do
    expect(chef_run).to render_file("/etc/nginx/sites-available/site_practice").with_content(/[\s]+listen[\s]+8080;/)
  end
end
