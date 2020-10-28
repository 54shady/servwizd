# cpu is ip address of server aa.bb.cc.dd
# authorized root login
cat ~/.ssh/id_rsa.pub | ssh -l root cpu "cat > ~/.ssh/authorized_keys"

# add anonymous as root
ssh -l root cpu "useradd -m -u 0 -o -g root -G root anonymous"
ssh -l root cpu "echo 0 | passwd --stdin anonymous"

# config anonymous ssh login
ssh -l root cpu "sed -i s'/root/root anonymous/' /etc/ssh/sshd_config"
ssh -l root cpu "service sshd restart"

ssh -l anonymous cpu "mkdir ~/.ssh"
cat ~/.ssh/id_rsa.pub | ssh -l anonymous cpu "cat > ~/.ssh/authorized_keys"

# config bash
scp dot_bashrc_mini anonymous@cpu:~/.bashrc

# config vim
scp vim.tar anonymous@cpu:~/
ssh -l anonymous cpu "tar xvf vim.tar"
