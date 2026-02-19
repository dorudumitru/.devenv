sudo rm -rf /opt/visualvm*

curl -s https://api.github.com/repos/oracle/visualvm/releases/latest |
  grep "browser_download_url.*visualvm_.*zip" |
  cut -d : -f 2,3 |
  tr -d \" |
  wget -P "$HOME/Downloads" -qi -

cd "$HOME"/Downloads || exit
unzip visualvm*.zip
rm visualvm*.zip

sudo mv "$HOME"/Downloads/visualvm* /opt/

echo -e "\nVisualVM installed successfully!"
