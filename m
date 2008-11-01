Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:54621 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754327AbYKCXaF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 18:30:05 -0500
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Kx8ry-0008Mx-W1
	for linux-wireless@vger.kernel.org; Mon, 03 Nov 2008 23:30:02 +0000
Received: from host220-22-dynamic.53-82-r.retail.telecomitalia.it ([82.53.22.220])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 03 Nov 2008 23:30:02 +0000
Received: from msan by host220-22-dynamic.53-82-r.retail.telecomitalia.it with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 03 Nov 2008 23:30:02 +0000
To: linux-wireless@vger.kernel.org
From: msan <msan@email.it>
Subject: problems with ath5k driver.
Date: Sat, 1 Nov 2008 21:39:48 +0000 (UTC)
Message-ID: <geiib4$apo$2@ger.gmane.org> (sfid-20081104_003014_378510_AC82F564)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hallo.
Sorry for my bad english.
I have an Esprimo D9500 Fujitsu Semens notebook.
My lspci reports for wireless card: "06:00.0 Ethernet controller: Atheros 
Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 
04)"
Dmesg says: "ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 
0x70)".
Iwconfig says: "
wmaster0  no wireless extensions.

wlan0     IEEE 802.11  ESSID:"" 
          Mode:Managed  Frequency:2.412 GHz  Access Point: Not-
Associated  
          Tx-Power=20 dBm  
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B  
          Encryption key:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

When I run "iwlist wlan0 scan" it says:" no scan results".
I can't access to any wireless lan, it seems that my atheros card doesn't 
work.
With another card, a Lonshine, I can connect to my wifi lan but with 
Atheros it is impossible.
There is any support for AR2425 chip?


