Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:45496 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbYLFRcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 12:32:23 -0500
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH] stlc45xx: wi-fi driver for stlc4550/4560 chipset
To: linux-wireless@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Date: Sat, 06 Dec 2008 19:32:05 +0200
Message-ID: <20081206173056.6853.95209.stgit@tikku> (sfid-20081206_183235_989478_4691C451)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I would like to submit stlc45xx for inclusion to wireless-testing
tree. Currently the main users are Nokia N800 and N810 products.

Even though this driver has similarities with p54, I still think it
would be a good idea to have the driver in Linux mainline. Linux omap
community would benefit from this, having a wi-fi driver in the kernel
would make the use of N800 and N810 a lot easier. p54 support for these
chipsets is not finished yet.

There is still some work to do, for example, add necessary client power
save support to mac80211 and modify stlc45xx to use it. Also stlc45xx
does not yet use platform data to get all board specific settings, but
I will fix that later. And countless others which I don't list here.

Please consider including this driver to the wireless-testing tree.

---

Kalle Valo (1):
      Add stlc45xx, wi-fi driver for stlc4550/4560


 MAINTAINERS                          |    8 
 drivers/net/wireless/Kconfig         |    9 
 drivers/net/wireless/Makefile        |    2 
 drivers/net/wireless/stlc45xx.c      | 2594 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/stlc45xx.h      |  285 ++++
 drivers/net/wireless/stlc45xx_lmac.h |  434 ++++++
 6 files changed, 3332 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/stlc45xx.c
 create mode 100644 drivers/net/wireless/stlc45xx.h
 create mode 100644 drivers/net/wireless/stlc45xx_lmac.h

