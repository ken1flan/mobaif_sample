Vagrant.configure("2") do |config|
  config.vm.box = "jasonc/centos7-32bit"

  config.vm.provision :shell, :inline => <<-EOT
    sudo yum install -y perl  # TODO: latest
    sudo yum install -y perl-devel
    sudo yum install -y perl-App-cpanminus
  EOT
end
