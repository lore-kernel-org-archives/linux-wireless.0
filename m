Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35883 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab2FEVz3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 17:55:29 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/8] bcma: add PCI ID for BCM43224
Date: Tue,  5 Jun 2012 23:55:03 +0200
Message-Id: <1338933307-13446-5-git-send-email-hauke@hauke-m.de> (sfid-20120605_235532_423270_79277B9A)
In-Reply-To: <1338933307-13446-1-git-send-email-hauke@hauke-m.de>
References: <1338933307-13446-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This ID was found on the PCIe wireless card on the board of a Netgear
WNDR3400 using a bcm4716. The device with this ID is identified by b43
as "Broadcom 43224 WLAN".

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/host_pci.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index f7fbae7..747efb7 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -269,6 +269,7 @@ static SIMPLE_DEV_PM_OPS(bcma_pm_ops, bcma_host_pci_suspend,
 
 static DEFINE_PCI_DEVICE_TABLE(bcma_pci_bridge_tbl) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x0576) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 43224) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4331) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4353) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4357) },
-- 
1.7.9.5

