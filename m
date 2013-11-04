Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22503 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab3KDLv2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 06:51:28 -0500
Date: Mon, 4 Nov 2013 14:51:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: brcm80211-dev-list@broadcom.com
Cc: linux-wireless@vger.kernel.org
Subject: How to get BRCM to work?
Message-ID: <20131104115111.GM26669@mwanda> (sfid-20131104_125131_815691_0892FC84)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been trying to remember the trick to get BRCM to work and I can't
remember at all.  I'm using BCM4313.  I've enabled everything with BCMA
or BRCM in the config name.

The module loads and the device shows up if I type "ifconfig wlan0" but
network manager doesn't see it and wicd doesn't see it.  (These are old
versions of nm and wicd).

This used to work under 3.8 but I didn't save my .config...  :(

I've done a google search and it seems like the broadcom driver is still
a complete mess and you need to black list modules and hack everything
yourself on a per system basis?  Is that right?  Why can't we fix this
so it works?

regards,
dan carpenter
