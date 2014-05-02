Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37589 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbaEBEAG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2014 00:00:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Wg4dn-0004tD-Ii
	for linux-wireless@vger.kernel.org; Fri, 02 May 2014 06:00:04 +0200
Received: from pool-180.151.210.rev.spectranet.in ([pool-180.151.210.rev.spectranet.in])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 02 May 2014 06:00:03 +0200
Received: from haipavanhai by pool-180.151.210.rev.spectranet.in with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 02 May 2014 06:00:03 +0200
To: linux-wireless@vger.kernel.org
From: pavan <haipavanhai@gmail.com>
Subject: Kernel panic triggered as soon as DHCP IP acquired from router NETGEAR WNDR3700
Date: Fri, 2 May 2014 03:53:09 +0000 (UTC)
Message-ID: <loom.20140502T054430-24@post.gmane.org> (sfid-20140502_060017_014373_F493F4D0)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am using ath6kl - AR9374 chip in our product which has ARC platform.
wireless drivers used are from 

https://github.com/senthilb/ath6kl-compat-wireless/tree/olca-3.2.2

Steps followed

1. Inserted compat.ko, cfg80211.ko, ath6kl_usb.ko
2. Kernel on the platform is 2.6.26 + ARC platform
3. I could see wlan0 interface
4. Ran wpa_supplicant and noticed that module is associated with the router 
NETGEAR WNDR3700

5. Kernel panic observed as Misaligned access (ip_table + 0xac) triggered, 
this is after router issued IP to the ath6kl wireless module.

Any suggestions are very much helpful.

Regards,
Pavan

