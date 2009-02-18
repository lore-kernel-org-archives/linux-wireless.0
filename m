Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:53336 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751628AbZBRVcV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 16:32:21 -0500
To: rt2400-devel@lists.sourceforge.net
cc: linux-wireless@vger.kernel.org
Subject: No ProbeResp == dead interface?
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 18 Feb 2009 21:58:48 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20090218205849.5723293CD93@tippex.mynet.homeunix.org> (sfid-20090218_223225_992404_E03DEA73)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Every so often I get in syslog:
wlan0: No ProbeResp from current AP 00:18:39:c0:5f:50 - assume out of range

After that the interface carries no more traffic and the onlly way I've found 
to revive the card is to power cycle the machine. /etc/iniit.d/net.wlan 
restart does not work, and "ifconfig wlan0 up ; iwlist scan" shows no results. 
Is there another way to revive the card?

I'm on 2.6.29-rc3, and the card is: 
00:0a.0 Network controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)
        Subsystem: RaLink Device 2560
        Flags: bus master, slow devsel, latency 64, IRQ 11
        Memory at efffe000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: [40] Power Management version 2
        Kernel driver in use: rt2500pci
        Kernel modules: rt2500pci

/Anders

