Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from st11p01mm-asmtp005.mac.com ([17.172.204.240]:57134 "EHLO
	st11p01mm-asmtp005.mac.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758179Ab3GRNDf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jul 2013 09:03:35 -0400
Received: from [10.228.216.210] (unknown [31.55.55.184])
 by st11p01mm-asmtp005.mac.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Jan
  3 2012)) with ESMTPSA id <0MQ40063AS51VV30@st11p01mm-asmtp005.mac.com> for
 linux-wireless@vger.kernel.org; Thu, 18 Jul 2013 12:03:03 +0000 (GMT)
Subject: USB drivers supporting master mode with large number of stations
From: Matt Foster <matt_foster@me.com>
Content-type: text/plain; charset=us-ascii
Message-id: <4A31C912-E9AF-41BC-9A95-1A513A9F0571@me.com> (sfid-20130718_150339_382529_068F2604)
Date: Thu, 18 Jul 2013 13:03:02 +0100
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-version: 1.0 (1.0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've been using ath9k_htc happily for a while for low density access points. However I've recently bumped into the 8 stations limitation. 

Tweaking the firmware & macros in the kernel confirm that 8 is probably the limit as "bad things" happen much past this. I suppose if my coding was up to it stripping out all the crypto and just having open network support might free up enough memory in the firmware to up max stations - but it's not, at least not without some guidance. 

Of course there are always commercial APs available, however I'm looking for something that can feature as a full distro with at a total minimum OpenVPN and 3G dongle support for remote mgt. 

My platforms are embedded, so PCI based cards are not an option. 

Are there any USB based drivers out there that support more than 8 stations in master mode?

I suppose I'd also be possibly partially happy with an AP with a proper distro on it subject to the 3G/OpenVPN requirements, and the ability to run my own coded captive portal, iptables for quota support etc

Maybe OpenWRT does what I want, it's a very long time since I looked at that. 

Any suggestions more than welcome

Thanks

Matt

