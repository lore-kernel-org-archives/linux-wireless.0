Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from test.hauke-m.de ([5.39.93.123]:43106 "EHLO test.hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbaHWKWk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 06:22:40 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: zajec5@gmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] bcma: add PCI ID for spromless BCM43227
Date: Sat, 23 Aug 2014 12:22:31 +0200
Message-Id: <1408789351-5803-1-git-send-email-hauke@hauke-m.de> (sfid-20140823_122244_282841_B0E14F94)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the PCI ID a BCM43227 without a sprom.
This devices was found on a Netgear R6250 attached to a BCM4708 ARM SoC.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/host_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 294a7dd..42fcd6d 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -282,6 +282,7 @@ static const struct pci_device_id bcma_pci_bridge_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43a9) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43aa) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 43227) },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, bcma_pci_bridge_tbl);
-- 
1.9.1

