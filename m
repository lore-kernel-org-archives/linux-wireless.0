Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm16-vm0.bullet.mail.ird.yahoo.com ([77.238.189.192]:39032 "HELO
	nm16-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751735Ab2G0IOH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 04:14:07 -0400
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <1343074978.66314.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343075460.1623.YahooMailNeo@web28905.mail.ir2.yahoo.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EBA0C.106@lwfinger.net> <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com> <1343149616.67668.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EE086.6000304@lwfinger.net> <1343224463.22151.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343236780.36289.YahooMailNeo@web28901.mail.ir2.yahoo.com> <1343237104.35808.YahooMailNeo@web28905.mail.ir2.yahoo.com> <5010304E.6070005@lwfinger.net> <1343296732.22680.YahooMailNeo@web28905.mail.ir2.yahoo.com> <501121B5.4010305@lwfinger.net> <1343300503.96939.YahooMailNeo@web28902.mail.ir2.yahoo.com> <501129D9.4060407@lwfinger.net> <1343314190.31952.YahooMailNeo@web28901.mail.ir2.yahoo.com> <5011BC0A.8060600@lwfinger.net>
Message-ID: <1343376844.6746.YahooMailNeo@web28904.mail.ir2.yahoo.com> (sfid-20120727_101415_929753_4E6BA685)
Date: Fri, 27 Jul 2012 09:14:04 +0100 (BST)
From: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Reply-To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <5011BC0A.8060600@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have installed the (and rebooted)
  INSTALL /home/xabix/tmp/compat-wireless-2012-07-03/compat/compat.ko
  INSTALL /home/xabix/tmp/compat-wireless-2012-07-03/compat/sch_codel.ko
  INSTALL /home/xabix/tmp/compat-wireless-2012-07-03/compat/sch_fq_codel.ko
  INSTALL /home/xabix/tmp/compat-wireless-2012-07-03/drivers/misc/eeprom/eeprom_93cx6.ko
  INSTALL /home/xabix/tmp/compat-wireless-2012-07-03/drivers/net/wireless/rtl818x/rtl8180/rtl8180.ko
  INSTALL /home/xabix/tmp/compat-wireless-2012-07-03/drivers/net/wireless/rtl818x/rtl8187/rtl8187.ko
  INSTALL /home/xabix/tmp/compat-wireless-2012-07-03/net/mac80211/mac80211.ko
  INSTALL /home/xabix/tmp/compat-wireless-2012-07-03/net/rfkill/rfkill-regulator.ko
  INSTALL /home/xabix/tmp/compat-wireless-2012-07-03/net/wireless/cfg80211.ko
  DEPMOD  3.4.6-custom

hostapd -dd /etc/hostapd/hostapd.conf
Configuration file: /etc/hostapd/hostapd.conf
ctrl_interface_group=0
nl80211: Register Action command failed: ret=-19 (No such device)
nl80211: Register Action match - hexdump(len=1): 06
nl80211: Failed to register Action frame processing - ignore for now
nl80211: Add own interface ifindex 3
nl80211: Add own interface ifindex 0
Could not read interface wlan0 flags: No such device
nl80211 driver initialization failed.
rmdir[ctrl_interface]: No such file or directory
ELOOP: remaining socket: sock=4 eloop_data=0x8fe48f0 user_data=0x8fe6760 handler=0x807c5e0
ELOOP: remaining socket: sock=6 eloop_data=0x8fe8548 user_data=(nil) handler=0x8086770

which is the same with your script:
sudo ./control_ap.sh start wlan0 eth0
Starting AP mode for wlan0 at address 192.168.0.200
hostapd: no process found
isc-dhcp-relay: no process found
wlan0: ERROR while getting interface flags: No such device
wlan0: ERROR while getting interface flags: No such device
SIOCSIFADDR: No such device
wlan0: ERROR while getting interface flags: No such device
touch: cannot touch `/var/lib/dhcp/db/dhcpd.leases': No such file or directory
Configuration file: /home/xabix/hostapd.conf
Could not read interface wlan0 flags: No such device
nl80211 driver initialization failed.
rmdir[ctrl_interface]: No such file or directory
ELOOP: remaining socket: sock=4 eloop_data=0x96d1910 user_data=0x96d3720 handler=0x807c5e0
ELOOP: remaining socket: sock=6 eloop_data=0x96d5538 user_data=(nil) handler=0x8086770

What else can I try?

Thanks
XabiX
