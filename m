Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39928 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161393AbXBZXMx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Feb 2007 18:12:53 -0500
Subject: [PATCH] bcm43xx-d80211: fix a sparse warning
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 00:12:34 +0100
Message-Id: <1172531554.3870.208.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a missing prototype sparse complains about.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 drivers/net/wireless/d80211/bcm43xx/bcm43xx_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-dev.orig/drivers/net/wireless/d80211/bcm43xx/bcm43xx_pci.c	2007-02-27 00:10:30.974692803 +0100
+++ wireless-dev/drivers/net/wireless/d80211/bcm43xx/bcm43xx_pci.c	2007-02-27 00:10:56.574692803 +0100
@@ -27,7 +27,7 @@
 
 #include <linux/pci.h>
 #include <linux/ssb/ssb.h>
-
+#include "bcm43xx_pci.h"
 
 static const struct pci_device_id bcm43xx_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4301) },


