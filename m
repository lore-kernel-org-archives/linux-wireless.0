Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:59475 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab0C0MZJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Mar 2010 08:25:09 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1NvV4Z-00084C-Nu
	for linux-wireless@vger.kernel.org; Sat, 27 Mar 2010 13:25:03 +0100
Received: from pc10.km-lan-2.netvisio.net ([pc10.km-lan-2.netvisio.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 27 Mar 2010 13:25:03 +0100
Received: from goldenstranger by pc10.km-lan-2.netvisio.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 27 Mar 2010 13:25:03 +0100
To: linux-wireless@vger.kernel.org
From: Golden <goldenstranger@yahoo.com>
Subject: Re: =?utf-8?b?ZmlybXdhcmVfbG9hZGluZ19zdG9yZTo=?= vmap() failed, broken firmware with kernles .27 - .30
Date: Sat, 27 Mar 2010 12:22:06 +0000 (UTC)
Message-ID: <loom.20100327T131226-160@post.gmane.org>
References: <733969.9491.qm@web56807.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bug, as mentioned above is present in 2.6.30 as well, though with a slightly
different error message, but the with same result - failure.

With latest compat-wiereless versions installed, when the zd1211 dongle is
plugged, an wlanX interface is being initialized, but when 'ifconfig wlanX up'
is issued, the cursor hangs for about 1 minute and driver fails to load the
firmware, despite the fact that the fw is installed and working with the default
kernel drivers and drivers from compat-wireless from December.

LOG:

zd1211rw 5-1:1.0: phy1
usb 5-1: firmware: requesting zd1211/zd1211b_ub
usb 5-1: Could not load firmware file zd1211/zd1211b_ub. Error number -2
zd1211rw 5-1:1.0: couldn't load firmware. Error number -2 




