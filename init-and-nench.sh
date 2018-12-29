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

echo Install Docker, nvim
apt install -y \
    apt-transport-https \
    ca-certificates \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository -y \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
add-apt-repository -y ppa:neovim-ppa/unstable
apt update -y
apt install -y docker-ce
apt install -y neovim
apt install -y unattended-upgrades
apt upgrade -y

function wS() { sudo -iu $USER bash -c "$@"; }

echo Config nvim
wS 'curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
wS 'mkdir $HOME/.config'
wS 'git clone https://github.com/mostrecent/nvim.git $HOME/.config/nvim'
wS 'nvim +PlugInstall +qa'
wS 'echo "  color azure" >> $HOME/.config/nvim/init.vim'

echo Config tmux
wS 'git clone https://github.com/mostrecent/tmux.git $HOME/.config/tmux'
wS 'ln -s $HOME/.config/tmux/.tmux.conf $HOME/.tmux.conf'

echo Install nvm and latest Node and npm
wS 'curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash'
ws 'nvm install --lts --latest-npm'

echo Testrun
wS 'nvim --startuptime nvim.log +qa'
wS '(curl -s wget.racing/nench.sh | bash; curl -s wget.racing/nench.sh | bash) 2>&1 | tee nench.log'
