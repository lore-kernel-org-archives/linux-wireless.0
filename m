Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:57510 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbYACSEw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2008 13:04:52 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43-ssb-bridge: Add PCI ID for BCM43XG
Date: Thu, 3 Jan 2008 19:03:09 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801031903.10070.mb@bu3sch.de> (sfid-20080103_180455_569393_18BD64AD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the PCI ID 0x4329 for the BCM43XG.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is stuff for 2.6.25

Index: wireless-2.6/drivers/ssb/b43_pci_bridge.c
===================================================================
--- wireless-2.6.orig/drivers/ssb/b43_pci_bridge.c	2007-12-11 01:08:40.000000000 +0100
+++ wireless-2.6/drivers/ssb/b43_pci_bridge.c	2008-01-03 18:08:44.000000000 +0100
@@ -28,6 +28,7 @@ static const struct pci_device_id b43_pc
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4324) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4325) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4328) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4329) },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, b43_pci_bridge_tbl);
