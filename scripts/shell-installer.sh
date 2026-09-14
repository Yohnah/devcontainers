#!/bin/bash
set -e
export OSH="$SHELL_INSTALL/oh-my-bash"
mkdir -p "$SHELL_INSTALL" /etc/sudoers.d /etc/profile.d
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
#curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh | bash -s -- --unattended


echo 'Defaults env_keep += "OSH"' >> /etc/sudoers.d/preserve-om
echo 'Defaults env_keep += "OSH_THEME"' >> /etc/sudoers.d/preserve-om
chmod 0440 /etc/sudoers.d/preserve-om
chmod -R 755 $OSH
sed -i 's/^OSH_THEME=.*/OSH_THEME="${OSH_THEME}"/' /root/.bashrc

echo 'plugins=(git)' > /etc/profile.d/omb.sh
echo 'DISABLE_AUTO_UPDATE="true"' >> /etc/profile.d/omb.sh
echo 'if [ -f "$OSH/oh-my-bash.sh" ]; then' >> /etc/profile.d/omb.sh
echo '  source "$OSH/oh-my-bash.sh"' >> /etc/profile.d/omb.sh
echo 'fi' >> /etc/profile.d/omb.sh

echo "Oh My Bash installed"
