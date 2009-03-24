Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46947 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758554AbZCXJjM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 05:39:12 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Add BCM4307 PCI-ID
Date: Tue, 24 Mar 2009 10:36:48 +0100
Cc: yoann <yoann71@msn.com>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903241036.48652.mb@bu3sch.de> (sfid-20090324_103922_559399_9A1FBFBB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

00:09.0 Network controller [0280]: Broadcom Corporation BCM4307 Ethernet Controller [14e4:4306] (rev 03)
    Subsystem: Broadcom Corporation BCM4307 Ethernet Controller [14e4:4306]
    Flags: bus master, fast devsel, latency 32, IRQ 10
    Memory at d7000000 (32-bit, non-prefetchable) [size=8K]
    Kernel driver in use: b43-pci-bridge
    Kernel modules: ssb

Reported-by: yoann <yoann71@msn.com>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Index: wireless-testing/drivers/ssb/b43_pci_bridge.c
===================================================================
--- wireless-testing.orig/drivers/ssb/b43_pci_bridge.c	2009-03-24 10:34:43.000000000 +0100
+++ wireless-testing/drivers/ssb/b43_pci_bridge.c	2009-03-24 10:34:56.000000000 +0100
@@ -18,6 +18,7 @@
 
 static const struct pci_device_id b43_pci_bridge_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4301) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4306) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4307) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4311) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4312) },

-- 
Greetings, Michael.
