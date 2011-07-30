Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fallback-out2.mxes.net ([216.86.168.191]:11802 "EHLO
	fallback-in2.mxes.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751443Ab1G3RUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2011 13:20:30 -0400
Received: from mxout-07.mxes.net (mxout-07.mxes.net [216.86.168.182])
	by fallback-in1.mxes.net (Postfix) with ESMTP id 06AF52FDBF9
	for <linux-wireless@vger.kernel.org>; Sat, 30 Jul 2011 13:14:38 -0400 (EDT)
Received: from home.eagach.dyndns.org (unknown [81.187.127.120])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.mxes.net (Postfix) with ESMTPSA id D61FF22E1FB
	for <linux-wireless@vger.kernel.org>; Sat, 30 Jul 2011 13:14:35 -0400 (EDT)
Date: Sat, 30 Jul 2011 18:14:33 +0100
From: Laurence Darby <ldarby@tuffmail.com>
To: linux-wireless@vger.kernel.org
Subject: I'm confused and angry
Message-Id: <20110730181433.50bd32db.ldarby@tuffmail.com> (sfid-20110730_192035_874331_4782FF6D)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Is there an obvious list of consumer products (NOT chipsets) that
hostapd supports that I'm missing? 

I want to make a wireless Access Point, using either a USB dongle, PCI
card, or PCIE x1 card.  I have already got a DHCP server and NAT in
both my desktop PC and router, I don't want to pay for an expensive
external wireless router which would be a 3rd DHCP and NAT.

None of the consumer devices' websites say which chipset they use, and none
the chipset manufactures' sites say what consumer products use their
chipset, so I can't just search for devices that support this.

I've foolishly just bought a Netgear WNA1100, because it was "close
enough" to a Netgear WNA1000, which possibly supports AP mode, but that
wasn't available.

I thought it got away with it, because this page:
http://linuxwireless.org/en/users/Drivers/ath9k_htc says that driver
supports AP mode.

I've upgraded to Linux 3.0 and installed the htc_9271.fw firmware, and
the device shows up in /proc/net/dev, but now hostapd is giving me the
errors:

rfkill: Cannot open RFKILL control device
Hardware does not support configured mode
wlan0: IEEE 802.11 Hardware does not support configured mode (2)
Could not select hw_mode and channel. (-2)
wlan0: Unable to setup interface.
rmdir[ctrl_interface]: No such file or directory

Does this device and driver support AP mode or not?  If the driver
doesn't, then the web page is wrong.  

If the driver does but the device doesn't, then the website should make
that clear.

I'm not bothered at all if the WNA1100 was a waste of money, it's the
amount of time I've wasted on this so far.

Please CC me on any responses, I'm not subscribed.

Thanks,
Laurence
