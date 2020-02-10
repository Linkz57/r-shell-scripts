echo "What's the FQDM of the Landscape server you want to use?"
read landscape


## disable some Ubuntu default on-login information
sudo chmod -x /etc/update-motd.d/00-header 
sudo chmod -x /etc/update-motd.d/10-help-text 
sudo chmod -x /etc/update-motd.d/80-livepatch 
sudo chmod -x /etc/update-motd.d/50-motd-news
sudo mv /lib/systemd/system/motd-news.service /lib/systemd/system/motd-news.service.disabled


## Configure Graphite and rSyslog monitoring
sudo apt update
sudo apt install -y collectd --no-install-recommends
sudo sed -i '0,/FQDNLookup true/s//#FQDNLookup true/' /etc/collectd/collectd.conf  ## FQDNs are too long to look nice in Graphana, so disable that here.
sudo sed -i "0,/\#Hostname \"localhost\"/s//Hostname \"$(hostname)\"/" /etc/collectd/collectd.conf  ## just use the hostname, much prettier
sudo sed -i '0,/#LoadPlugin uptime/s//LoadPlugin uptime/' /etc/collectd/collectd.conf  ## enable uptime monitoring
sudo sed -i '0,/#LoadPlugin write_graphite/s//LoadPlugin write_graphite/' /etc/collectd/collectd.conf  ## enable sending this collected info to Graphite
echo '<Plugin write_graphite>
	<Node "example">
		Host "mah.server.ip.address"
		Port "1234567"
		Protocol "tcp"
		ReconnectInterval 0
		LogSendErrors true
		Prefix "yeah."
		Postfix ".whynot"
		StoreRates true
		AlwaysAppendDS false
		EscapeCharacter "_"
		SeparateInstances false
		PreserveSeparator false
		DropDuplicateFields false
	</Node>
</Plugin>
' | sudo tee -a /etc/collectd/collectd.conf
echo '*.* @another.server.ip.address' | sudo tee /etc/rsyslog.d/11-linkz57.conf  ## tell everything that happens on this system to this IP address
sudo systemctl enable collectd.service
sudo systemctl enable rsyslog.service
sudo systemctl restart collectd.service
sudo systemctl restart rsyslog.service


## set up Landscape for auto updates and stuff
sudo apt update
sudo apt upgrade -y
sudo apt install landscape-client -y
printf "[client]\nlog_level = info\ndata_path = /var/lib/landscape/client\nssl_public_key = /etc/landscape/landscape_server_ca.crt\naccount_name = standalone\nurl = https://$landscape/message-system\nping_url = http://$landscape/ping\naccess_group = global\ntags = auto_update,notproduction,max10\ncomputer_title = Several Species of Small Furry Animals Gathered Together in a Cave and Grooving with a Pict" | sudo tee /etc/landscape/client.conf
sudoedit /etc/landscape/client.conf
## for self-hosted landscape instances
ssh $landscape "cat /etc/ssl/certs/landscape_server_ca.crt" | sudo tee /etc/landscape/landscape_server_ca.crt
