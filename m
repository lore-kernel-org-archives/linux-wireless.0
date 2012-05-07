Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45131 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932479Ab2EGVFX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 17:05:23 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org, m@bues.ch,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] ssb: add PCI IDs 0x4322 and 0xa8d6
Date: Mon,  7 May 2012 23:04:53 +0200
Message-Id: <1336424693-25926-1-git-send-email-hauke@hauke-m.de> (sfid-20120507_230527_278246_1D0BC5AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 0x4322 ID is found on the BCM4322 used on some SoCs like the
Linksys WRT610N V1 connected to a BCM4705. The 0xa8d6 ID is found on
the BCM43222 used on some other SoCs like the D-Link DSL-2760U
connected to a BCM63xx.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/b43_pci_bridge.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ssb/b43_pci_bridge.c b/drivers/ssb/b43_pci_bridge.c
index bad7ba5..f824fec 100644
--- a/drivers/ssb/b43_pci_bridge.c
+++ b/drivers/ssb/b43_pci_bridge.c
@@ -29,11 +29,13 @@ static const struct pci_device_id b43_pci_bridge_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4319) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4320) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4321) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4322) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4324) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4325) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4328) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4329) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x432b) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0xa8d6) },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, b43_pci_bridge_tbl);
-- 
1.7.9.5

