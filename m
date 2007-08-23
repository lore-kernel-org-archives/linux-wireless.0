Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:56335
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933457AbXHWWax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 18:30:53 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Add PCI id's for BCM4301
Date: Fri, 24 Aug 2007 00:29:16 +0200
Cc: Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200708240029.16928.mb@bu3sch.de>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <Larry.Finger@lwfinger.net>

This patch adds the pci ids for BCM4301 and BCM4303 to the bridge
module included in ssb. These devices use b43legacy.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev/drivers/ssb/b43_pci_bridge.c
===================================================================
--- wireless-dev.orig/drivers/ssb/b43_pci_bridge.c
+++ wireless-dev/drivers/ssb/b43_pci_bridge.c
@@ -15,6 +15,7 @@
 
 
 static const struct pci_device_id b43_pci_bridge_tbl[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4301) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4307) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4311) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4312) },

-- 
Greetings Michael.
