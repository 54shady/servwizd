#@cpu is ip address of server aa.bb.cc.dd
# authorized root login
cat ~/.ssh/id_rsa.pub | ssh root@cpu "cat > ~/.ssh/authorized_keys"

# add anonymous as root
ssh root@cpu "useradd -m -u 0 -o -g root -G root anonymous"
ssh root@cpu "echo 0 | passwd --stdin anonymous"

# config anonymous ssh login
ssh root@cpu "sed -i s'/root/root anonymous/' /etc/ssh/sshd_config"
ssh root@cpu "service sshd restart"

ssh anonymous@cpu "mkdir ~/.ssh"
cat ~/.ssh/id_rsa.pub | ssh anonymous@cpu "cat > ~/.ssh/authorized_keys"

# config bash
scp dot_bashrc_mini anonymous@cpu:~/.bashrc

# config vim
cat vim.tar | ssh anonymous@cpu "tar xvf -"
ssh anonymous@cpu "ln -s ~/.vim/vimrc ~/.vimrc"
