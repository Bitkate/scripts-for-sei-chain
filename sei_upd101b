echo "               ===              "
echo "       ==================       "
echo "================================"
echo "Welcome to scripts from Bitkate!"
echo "================================"
echo "       ==================       "
echo "               ===              "

echo ""
echo "Updating SeiNetwork FullNode 1.0.0b to 1.0.1b"

echo ""
echo "Stopping service"
echo ""
service seinet stop
cd ~
cp ~/sei-chain/account-*.txt ~/.sei-chain/
cd ~/sei-chain/

echo "Pull changes from sei github"
echo ""
git pull --no-edit origin 1.0.1beta
export PATH=$PATH:/usr/local/go/bin

echo ""
echo "Compiling new seid"
echo ""
make install

echo ""
echo "Changing seid binary path in systemd service"
echo ""
cat > /tmp/repl.py << EOF
fp = '/etc/systemd/system/seinet.service'

ot = open(fp, 'r').read()
ot = ot.replace("/root/sei-chain/build/seid start", "/root/go/bin/seid start --home /root/.sei-chain")

nf = open(fp, 'w')
nf.write(ot)
nf.close()
EOF

python3 /tmp/repl.py
rm /tmp/repl.py

systemctl daemon-reload
service seinet start 

echo ""
echo "================================================="
echo "Update complete"
echo "Check status: service seinet status"
echo "Check logs:   tail -f /var/log/syslog | grep seid"
echo ""
