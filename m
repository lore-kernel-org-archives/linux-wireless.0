Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp146.mail.ukl.yahoo.com ([77.238.184.77]:24508 "HELO
	smtp146.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751375AbZIPEsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 00:48:06 -0400
Message-ID: <4AB06E01.6010604@yahoo.es>
Date: Wed, 16 Sep 2009 06:48:01 +0200
From: Albert Herranz <albert_herranz@yahoo.es>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: Remove BROKEN attribute from SDIO
References: <200909160113.57539.mb@bu3sch.de>
In-Reply-To: <200909160113.57539.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> SDIO works (more or less), so remove the BROKEN dependency and
> let people test it.

The master-2009-09-14 branch of linux-wireless tree has been
successfully tested in combination with the patches below on a
Nintendo Wii video game console using the OpenFWWF firmware version 5.2
and setting modparam_qos set to 0.

[PATCH] b43: fix build error if !CONFIG_B43_LEDS
[PATCH] b43: Don't abuse wl->current_dev in the led work
[PATCH] b43: Disable PMQ mechanism
[PATCH] b43: Add optional verbose runtime statistics
[PATCH] b43: Fix IRQ sync for SDIO
007-mac80211-use-netif-rx-ni.patch [1]
[PATCH] b43: Fix SDIO interrupt handler deadlock 
005-b43-pio-always-use-block-io-for-data.patch [2]
[PATCH] b43: Do not use _irqsafe callbacks
[PATCH] b43: Add Soft-MAC SDIO device support  
[PATCH] b43: Rewrite suspend/resume code
[PATCH v2] sdio: pass whitelisted cis funce tuples to sdio drivers
[PATCH v2] sdio: recognize io card without powercycle

Tested-by: Albert Herranz <albert_herranz@yahoo.es>

[1] http://bu3sch.de/patches/wireless-testing/20090914-2326/patches/007-mac80211-use-netif-rx-ni.patch
[2] http://bu3sch.de/patches/wireless-testing/20090914-2326/patches/005-b43-pio-always-use-block-io-for-data.patch

