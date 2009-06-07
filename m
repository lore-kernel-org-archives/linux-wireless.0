Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cernmx13.cern.ch ([137.138.142.200]:45693 "EHLO
	cernmx13.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbZFGM3r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 08:29:47 -0400
Message-ID: <4A2BB2BB.7000605@cern.ch>
Date: Sun, 7 Jun 2009 14:29:47 +0200
From: Wojciech Zabolotny CERN <wojciech.zabolotny@cern.ch>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
Subject: Re: Which firmware for Belkin F5D7050 (ISL3880 + NET2280)
References: <4A2BA2E0.7020709@cern.ch>
In-Reply-To: <4A2BA2E0.7020709@cern.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've managed to run my NIC with the older firmware:
http://daemonizer.de/prism54/prism54-fw/fw-usb/2.13.1.0.lm86.arm

Now I get the following output in dmesg:

cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: US
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
    (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
    (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
    (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
    (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
cfg80211: Calling CRDA for country: US
usb 1-4: firmware: requesting isl3886usb
phy0: p54 detected a LM86 firmware
p54: rx_mtu reduced from 3240 to 2392
phy0: FW rev 2.13.1.0 - Softmac protocol 5.5
phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
phy0: hwaddr 00:30:43:11:33:39, MAC:isl3886 RF:Frisbee
wmaster0 (p54usb): not using net_device_ops yet
phy0: Selected rate control algorithm 'minstrel'
wlan0 (p54usb): not using net_device_ops yet
usbcore: registered new interface driver p54usb


Then everything works correctly.
So it seems, that the new firmware is just incompatible with this card :-(.
-- 
BR, WZab

