include_recipe 'simple_iptables'

# デフォルトポリシーとしてINPUTはDROP
simple_iptables_policy 'INPUT' do
  policy 'DROP'
end

# ルールブックは許可
simple_iptables_rule 'local' do
  rule '--in-interface lo'
  jump 'ACCEPT'
end

# すでに接続済みのものは許可
simple_iptables_rule 'established' do
  rule '-m conntrack --ctstate ESTABLISHED,RELATED'
  jump 'ACCEPT'
end

# SSH接続を許可
simple_iptables_rule 'ssh' do
  rule '--proto tcp --dport 22'
  jump 'ACCEPT'
end

# HTTP, HTTPSを許可
simple_iptables_rule 'http' do
  rule ['--proto tcp --dport 80',
        '--proto tcp --dport 443']
  jump 'ACCEPT'
end
