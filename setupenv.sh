#/bin/bash

function print_usage()
{
	echo "auto setup linux machine"
	echo "setupenv.sh <user> <ip>"
}

[ $# -lt 2 ] && print_usage && exit

user=$1
ip=$2
port=$3

# default port 22
if [ -z $port ]; then
	port=22
fi

ssh -p $port $user@$ip "mkdir -p ~/.ssh"
cat ~/.ssh/id_rsa.pub | ssh -p $port $user@$ip "cat >> ~/.ssh/authorized_keys"

# add anonymous as $user
ssh -p $port $user@$ip "useradd -m -u 0 -o -g root -G root anonymous"
ssh -p $port $user@$ip "echo 0 | passwd --stdin anonymous"

# config anonymous ssh login
ssh -p $port $user@$ip "sed -i s'/root/root anonymous/' /etc/ssh/sshd_config"
ssh -p $port $user@$ip "service sshd restart"

ssh -p $port anonymous@$ip "mkdir ~/.ssh"
cat ~/.ssh/id_rsa.pub | ssh -p $port anonymous@$ip "cat > ~/.ssh/authorized_keys"

# config bash
scp -P $port dot_bashrc_mini anonymous@$ip:~/.bashrc

# config vim
cat vim.tar | ssh -p $port anonymous@$ip "tar xvf -"
ssh -p $port anonymous@$ip "ln -s ~/.vim/vimrc ~/.vimrc"
