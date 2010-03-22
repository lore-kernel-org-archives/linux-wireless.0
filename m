Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:42320 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab0CVCpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Mar 2010 22:45:22 -0400
Received: by qyk9 with SMTP id 9so2952062qyk.1
        for <linux-wireless@vger.kernel.org>; Sun, 21 Mar 2010 19:45:22 -0700 (PDT)
From: Steven Wheeler <stevenwheel@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: Problems with Netgear WG511v1 PCMCIA
Date: Sun, 21 Mar 2010 21:45:19 -0500
Message-ID: <002a01cac969$b726e8d0$2574ba70$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am attempting to resurrect my old Toshiba Portege 3110CT laptop
Installed Slackware 12.2 on it and all is working well except for my
WG511v1.
Last time I used it several years ago, I remember it working fine.

I believe I have everything configured in the wireless startup scripts, it
all seems to run (as shown below), although I have to manually enter
ifconfig wlan0 up before it shows up
It appears to me that the card is working except for the fact that it shows
no Single Strength (even though it is sitting within 10 ft of my wireless
AP)
Iwlist wlan0 scan returns with
wlan0    no scan results

I have reached my knowledge limit and if anyone has a suggestion to try I
would appreciate it.  I am really hoping I can use this card since money is
tight right now

iwconfig wlan0
wlan0     IEEE 802.11bg  ESSID:"tew639"  
          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-Associated   
          Tx-Power=27 dBm   
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B   
          Encryption key:32B2-5821-0A   Security mode:open
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

Extract from /var/log/messages after card pulled and inserted.
Mar 21 21:29:00 PopsLT kernel: pccard: CardBus card inserted into slot 0
Mar 21 21:29:00 PopsLT kernel: pci 0000:01:00.0: PME# supported from D0 D1
D2 D3hot D3cold
Mar 21 21:29:00 PopsLT kernel: pci 0000:01:00.0: PME# disabled
Mar 21 21:29:00 PopsLT kernel: prism54pci 0000:01:00.0: enabling device
(0000 -> 0002)
Mar 21 21:29:00 PopsLT kernel: firmware: requesting isl3886
Mar 21 21:29:00 PopsLT kernel: p54: LM86 firmware
Mar 21 21:29:00 PopsLT kernel: p54: FW rev 2.13.1.0 - Softmac protocol 5.5
Mar 21 21:29:01 PopsLT kernel: p54: unknown eeprom code : 0x1
Mar 21 21:29:01 PopsLT kernel: p54: unknown eeprom code : 0x3
Mar 21 21:29:01 PopsLT kernel: p54: unknown eeprom code : 0x1905
Mar 21 21:29:01 PopsLT kernel: p54: unknown eeprom code : 0x1007
Mar 21 21:29:01 PopsLT kernel: p54: unknown eeprom code : 0x1008
Mar 21 21:29:01 PopsLT kernel: p54: unknown eeprom code : 0x1100
Mar 21 21:29:01 PopsLT kernel: phy1: hwaddr 00:09:5b:45:40:05, isl3890
Mar 21 21:29:01 PopsLT kernel: firmware: requesting isl3886
Mar 21 21:29:05 PopsLT logger: /etc/rc.d/rc.inet1:  /sbin/iwconfig wlan0
mode Managed
Mar 21 21:29:05 PopsLT logger: /etc/rc.d/rc.inet1:  /sbin/iwconfig wlan0
nick PopsLT
Mar 21 21:29:05 PopsLT logger: /etc/rc.d/rc.inet1:  /sbin/iwconfig wlan0
channel auto
Mar 21 21:29:05 PopsLT logger: /etc/rc.d/rc.inet1:  /sbin/iwconfig wlan0 key
************
Mar 21 21:29:05 PopsLT logger: /etc/rc.d/rc.inet1:  /sbin/iwconfig wlan0 key
restricted
Mar 21 21:29:05 PopsLT logger: /etc/rc.d/rc.inet1:  /sbin/iwconfig wlan0
rate 54M auto
Mar 21 21:29:05 PopsLT logger: /etc/rc.d/rc.inet1:  /sbin/iwconfig wlan0
essid "tew639"
Mar 21 21:29:05 PopsLT logger: /etc/rc.d/rc.inet1:  /sbin/iwconfig wlan0
essid "tew639"
Mar 21 21:29:05 PopsLT logger: /etc/rc.d/rc.inet1:  /sbin/dhcpcd -d -t 30
wlan0
Mar 21 21:29:05 PopsLT dhcpcd[2940]: MAC address = 00:09:5b:45:40:05

Thanks
Steven Wheeler

