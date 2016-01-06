require 'spec_helper'

describe 'ports' do
  describe port(80) do
    it { should be_listening }
  end

  describe port(22) do
    it { should be_listening }
  end
end

describe 'rbenv' do
  # rbenv group
  describe group('rbenv') do
    it { should exist }
  end

  describe user('vagrant') do
    it { should exist }
    it { should belong_to_group 'vagrant' }
  end

  # install rbenv
  describe command('source /etc/profile.d/rbenv.sh; which rbenv') do
    let(:disable_sudo) { true }
    its(:stdout) { should match /\/opt\/rbenv\/bin\/rbenv/ }
  end

  # rbenv.sh
  describe file('/etc/profile.d/rbenv.sh') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match(/^export RBENV_ROOT=\/opt\/rbenv$/) }
    its(:content) { should match(/^export PATH=\$RBENV_ROOT\/bin:\/opt\/rbenv\/plugins\/ruby_build\/bin:\$PATH$/) }
    its(:content) { should match(/^eval "\$\(rbenv init -\)"$/) }
  end

  # ruby-build
  describe file('/opt/rbenv/plugins/ruby_build') do
    it { should be_directory }
    it { should be_owned_by 'rbenv' }
    it { should be_grouped_into 'rbenv' }
    it { should be_mode 2755 }
  end

  describe file('/opt/rbenv/plugins/ruby_build/.git') do
    it { should be_directory }
    it { should be_owned_by 'rbenv' }
    it { should be_grouped_into 'rbenv' }
    it { should be_mode 2755 }
  end

  # install ruby
  ['2.2.4'].each do |ruby_version|
    describe command("source /etc/profile.d/rbenv.sh; rbenv versions | grep #{ruby_version}") do
      let(:disable_sudo) { true }
      its(:stdout) { should match(/#{Regexp.escape(ruby_version)}/) }
    end
  end

  describe command('source /etc/profile.d/rbenv.sh; rbenv global') do
    let(:disable_sudo) { true }
    its(:stdout) {should match /2\.2\.4/}
  end
end

describe 'nginx' do
  describe package('nginx') do
    it {should be_installed}
  end

  describe process('nginx') do
    it {should be_enabled}
    it {should be_running}
  end
end

describe 'unicorn' do
  describe process('unicorn') do
    it {should be_enabled}
  end

  describe file('/home/vagrant/app_root/current/tmp/unicorn.sock') do
    it { should be_socket }
  end
end
