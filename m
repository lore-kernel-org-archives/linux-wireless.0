Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:59456 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbYIVJcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 05:32:04 -0400
Received: from eagle4.localnet (koln-4db444db.pool.einsundeins.de [77.180.68.219])
	by whisper-net.dyndns.org (Postfix) with ESMTP id A8CD01A032
	for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2008 11:43:40 +0200 (CEST)
From: Julian Pietron <julian@whisper-net.de>
To: linux-wireless@vger.kernel.org
Subject: Problems with zd1211rw and TL-WN322G (TP-Link)
Date: Mon, 22 Sep 2008 11:31:54 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200809221131.55266.julian@whisper-net.de> (sfid-20080922_113209_182569_D92010EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hallo,

I bought a TP-Link TL-WN322G with ZyDas-Chipset. If I try to use it with the 
zd1211rw driver, the device is recognized, but an accesspoint scan via iwlist 
wlan1 scan fails with "Network is down". Trying to set up the interface 
manually using ifconfig wlan1 up fails with "SIOCSIFFLAGS: No such device".

The complete dmesg-output from plugging the stick in until the above error 
message reads as follows:

usb 2-2: new high speed USB device using ehci_hcd and address 8
usb 2-2: configuration #1 chosen from 1 choice
usb 2-2: reset high speed USB device using ehci_hcd and address 8
phy1: Selected rate control algorithm 'pid'
zd1211rw 2-2:1.0: phy1
firmware: requesting zd1211/zd1211b_ub
firmware: requesting zd1211/zd1211b_uphr
zd1211rw 2-2:1.0: RF MAXIM_NEW_RF 0x8 is not supported

After that, the red led of the stick is off and ifconfig wlan1 up or other 
commands involving the device don't work anymore (they hang until the stick is 
plugged off).
Used kernel is 2.6.26, but I encountered the same errors with a 2.6.22 and 
2.6.24 kernel.

I hope someone can give me a hint how to get this device to work properly.

Thanks in advance,
J. Pietron
