Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:37763 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3HTHjn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 03:39:43 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Add one more PCI ID for CUS198
Date: Tue, 20 Aug 2013 13:05:58 +0530
Message-Id: <1376984158-21810-1-git-send-email-sujith@msujith.org> (sfid-20130820_093946_749725_55CF3E32)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This is a AR9485/WB225 based card.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 76e8c35..3280798 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -59,6 +59,11 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 			 PCI_VENDOR_ID_AZWAVE,
 			 0x2126),
 	  .driver_data = ATH9K_PCI_CUS198 | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x126A),
+	  .driver_data = ATH9K_PCI_CUS198 | ATH9K_PCI_BT_ANT_DIV },
 
 	/* PCI-E CUS230 */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
-- 
1.8.3.4

