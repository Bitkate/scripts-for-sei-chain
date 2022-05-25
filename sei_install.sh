read -p "Enter MONIKER: " mon

echo ""
echo "=================="
echo "Installing updates"
echo "=================="
echo ""
apt update && apt upgrade -y

echo ""
echo "===================="
echo "Installing GO 1.18.2"
echo ""
wget https://go.dev/dl/go1.18.2.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.18.2.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile

echo ""
echo "============================"
echo "Installing sei-chain network"
echo "============================"
echo ""
git clone --depth 1 --branch 1.0.0beta https://github.com/sei-protocol/sei-chain.git
cd sei-chain/
go build -o build/seid ./cmd/sei-chaind/
export MONIKER="$mon"
./build/seid init $MONIKER --chain-id sei-testnet-1 -o
curl https://raw.githubusercontent.com/sei-protocol/testnet/master/sei-testnet-1/genesis.json > ~/.sei-chain/config/genesis.json
curl https://raw.githubusercontent.com/sei-protocol/testnet/master/sei-testnet-1/addrbook.json > ~/.sei-chain/config/addrbook.json

echo ""
echo "=================="
echo "Installing service"
echo "=================="
echo ""

cat > /etc/systemd/system/seinet.service << EOF
[Unit]
Description=Seinet
After=network.target

[Service]
User=root
Type=simple
ExecStart=/root/sei-chain/build/seid start
Restart=on-failure
LimitNOFILE=65535
WorkingDirectory=/root/sei-chain

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable seinet.service
systemctl start seinet.service

sleep 5
echo ""
echo "================"
echo "Checking service"
echo "================"
echo ""

systemctl status seinet.service
