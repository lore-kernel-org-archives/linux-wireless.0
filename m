Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1936 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab0IKQoR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 12:44:17 -0400
Date: Sat, 11 Sep 2010 09:44:09 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: gregkh@suse.de
cc: henryp@broadcom.com, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH] Fix URLs for firmware files.
Message-ID: <20100911164409.GA7432@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 6c45ba230e63b6ee85b9a51962e545d6d0e5698c Mon Sep 17 00:00:00 2001
From: Henry Ptasinski <henryp@broadcom.com>
Date: Sat, 11 Sep 2010 09:40:20 -0700
Subject: [PATCH] Fix URLs for firmware files.


Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
---
 drivers/staging/brcm80211/README |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/README b/drivers/staging/brcm80211/README
index 97fa01c..c3ba9bb 100644
--- a/drivers/staging/brcm80211/README
+++ b/drivers/staging/brcm80211/README
@@ -40,8 +40,8 @@ Firmware installation
 Firmware is available from the Linux firmware repository at:
 
 	git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
-	http://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
-	https://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
+	http://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git
+	https://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git
 
 For all chips, copy brcm/bcm43xx-0-610-809-0.fw and
 brcm/bcm43xx_hdr-0-610-809-0.fw to /lib/firmware/brcm (or wherever firmware is
-- 
1.6.3.3


