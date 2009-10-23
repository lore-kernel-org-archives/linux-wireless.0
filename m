Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout7.freenet.de ([195.4.92.97]:49997 "EHLO mout7.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbZJWOAe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 10:00:34 -0400
From: "Adhari" <wireless_support@adhari.de>
To: <linux-wireless@vger.kernel.org>
Subject: D-link USB Wlan Adapter DWA 160A  crashes after a while
Date: Fri, 23 Oct 2009 16:00:32 +0200
Message-ID: <005001ca53e9$307bde30$91739a90$@de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Everybody

I´m usind a D-link USB Wlan Adapter DWA 160A (ar9170usb) under Debian (kernel 2.6.31)

First when I connect this device, everything is fine. I have to do some measurements concerning Mipv6 (I´m only using Ipv6 here)
after a while using this W-lan Adapter (30 to 60mn) the system is not be able to receive any packets.


The only solution is to plug the USB interface out and to connect it again.
ifconfig down and up has no effect and sometimes rebooting either don´t correct this.

Any idea what the problem could be?



iwconfig wlan0 ==> 

wlan1     IEEE 802.11abgn  ESSID:"homenet"  
          Mode:Managed  Frequency:2.447 GHz  Access Point: Not-Associated   
          Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


Ifconfig wlan0 ==> 

wlan1     Link encap:Ethernet  HWaddr 00:22:b0:71:a0:f3  
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:1604 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1886 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:212557 (207.5 KiB)  TX bytes:296773 (289.8 KiB)


My message logs:

[ 1017.309330] device wlan1 entered promiscuous mode
[ 1057.151376] device wlan1 left promiscuous mode
[ 1069.824693] device wlan1 entered promiscuous mode
[ 1109.161762] device wlan1 left promiscuous mode
[ 1123.640991] device wlan1 entered promiscuous mode
[ 1130.289499] device wlan1 left promiscuous mode
[ 1270.206139] usb 5-2: kill pending tx urbs.
[ 1276.393756] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[ 1276.396863] r8169: eth0: link up



Thx

Hakim 

