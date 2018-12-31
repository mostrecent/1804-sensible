#!/bin/bash
if [ -z "$1" ]
    then
        USER=e
    else
        USER=$1
fi

echo Add user
useradd                 \
    --shell /bin/bash   \
    --create-home       \
    $USER
usermod                 \
    --append            \
    --groups sudo       \
    $USER
cp -r ~/.ssh /home/$USER/
chown -R $USER:$USER /home/$USER/.ssh
sed -ie 's/#PasswordAuthentication\syes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -ie 's/UsePAM\syes/UsePAM no/g' /etc/ssh/sshd_config

echo Install nvim
add-apt-repository -y ppa:neovim-ppa/unstable
apt update -y
apt install -y neovim
apt install -y unattended-upgrades
apt upgrade -y

function wS() { sudo -iu $USER bash -c "$@"; }

echo Config nvim
wS 'curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
wS 'mkdir $HOME/.config'
wS 'git clone https://github.com/mostrecent/nvim.git $HOME/.config/nvim'

echo Config tmux
wS 'git clone https://github.com/mostrecent/tmux.git $HOME/.config/tmux'
wS 'ln -s $HOME/.config/tmux/.tmux.conf $HOME/.tmux.conf'

echo Install nvm and latest Node and npm
wS 'curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash'
ws 'nvm install --lts --latest-npm'


# Manual steps:
#
# Set root and user password with passwd and passwd USER as root
