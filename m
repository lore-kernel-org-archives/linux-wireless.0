Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:34666 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbZHMRvE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 13:51:04 -0400
Received: from [195.4.92.21] (helo=11.mx.freenet.de)
	by mout2.freenet.de with esmtpa (ID ManuelSahm@freenet.de) (port 25) (Exim 4.69 #92)
	id 1MbeS6-0007g9-Mk
	for linux-wireless@vger.kernel.org; Thu, 13 Aug 2009 19:51:02 +0200
Received: from p4fc85837.dip.t-dialin.net ([79.200.88.55]:61527 helo=manuel)
	by 11.mx.freenet.de with esmtpa (ID ManuelSahm@freenet.de) (port 25) (Exim 4.69 #93)
	id 1MbeS6-0005ng-A9
	for linux-wireless@vger.kernel.org; Thu, 13 Aug 2009 19:51:02 +0200
From: "Manuel Sahm" <ManuelSahm@freenet.de>
To: <linux-wireless@vger.kernel.org>
Subject: WG: rt2500usb with kernel >=2.6.29
Date: Thu, 13 Aug 2009 19:51:36 +0200
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAAHPNBStbvZ9BluURSOZ8EsPCgAAAEAAAAMn6GLzQhQVLqs+4i7xoAioBAAAAAA==@freenet.de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

my usb wlan sticks aren´t working anymore - I cannot connect to an access
point.

I have got this two usb sticks:

Buffallo WLI-U2-KG54-AI
GIGABYTE AirCruiser G USB Adapter (GN-WBKG)

With Kernel 2.6.28.10 all seems to work fine..... with kernel >= 2.6.29 it
doesn´t work anymore ???
Bootup (dmesg) shows:

usb 1-1: default language 0x0409
usb 1-1: New USB device found, idVendor=1044, idProduct=8007
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 1-1: Product: 802.11g WLAN + Pen Drive
usb 1-1: Manufacturer: Ralink
usb 1-1: uevent
usb 1-1: usb_probe_device
usb 1-1: configuration #1 chosen from 1 choice
usb 1-1: adding 1-1:1.0 (config #1, interface 0)
usb 1-1:1.0: uevent
rt2500usb 1-1:1.0: usb_probe_interface
rt2500usb 1-1:1.0: usb_probe_interface - got id
phy0 -> rt2500usb_validate_eeprom: EEPROM recovery - NIC: 0xfff0
phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 1201, rf: 0005, rev:
00000005.
phy0: Selected rate control algorithm 'pid'
drivers/usb/core/inode.c: creating file '002'
hub 1-0:1.0: state 7 ports 2 chg 0000 evt 0002
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 5, CWmax:
10, Aifs: 2, TXop: 0.
phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 5, CWmax:
10, Aifs: 2, TXop: 0.
ADDRCONF(NETDEV_UP): wlan0: link is not ready

any ideas ? 
thanks very much

