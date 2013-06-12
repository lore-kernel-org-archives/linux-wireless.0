Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:37383 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab3FLWVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 18:21:25 -0400
Date: Wed, 12 Jun 2013 18:21:23 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: rvossen@broadcom.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org
Subject: brcmfmac sdio device id 0x4319 ?
Message-ID: <20130612222123.GB31667@titan.lakedaemon.net> (sfid-20130613_002128_840635_744E60A8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All,

I have a Seagate Wireless Plus I am trying to put a vanilla kernel on
(currently v3.10-rc5 for various omap DT bits).

I have the board booting and running a debian rootfs on the HD.  I just
got mmc to come up and I've discovered that the wireless card is vendor
0x02d0, device 0x4319.

My hope, once I got to this point, was that I would be able to use
the mainline, open source driver.  Unfortunately, it looks like brcmfmac
lost support for the 0x4319 while it was in staging.

The commit in question is:

  4dad253 staging: brcm80211: remove code for unsupported chip

Is adding it back in a bridge too far?

thx,

Jason.
