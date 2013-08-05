Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:59498 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab3HEJmE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 05:42:04 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] ath9k: Add more PCI IDs for WB225 cards
Date: Mon,  5 Aug 2013 15:08:28 +0530
Message-Id: <1375695508-1997-3-git-send-email-sujith@msujith.org> (sfid-20130805_114213_136025_77F00905)
In-Reply-To: <1375695508-1997-1-git-send-email-sujith@msujith.org>
References: <1375695508-1997-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/pci.c | 72 ++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 30652b4..76e8c35 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -72,6 +72,78 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 			 0xE075),
 	  .driver_data = ATH9K_PCI_CUS230 | ATH9K_PCI_BT_ANT_DIV },
 
+	/* WB225 */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_ATHEROS,
+			 0x3119),
+	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_ATHEROS,
+			 0x3122),
+	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 0x185F, /* WNC */
+			 0x3119),
+	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 0x185F, /* WNC */
+			 0x3027),
+	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_SAMSUNG,
+			 0x4105),
+	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_SAMSUNG,
+			 0x4106),
+	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_SAMSUNG,
+			 0x410D),
+	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_SAMSUNG,
+			 0x410E),
+	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_SAMSUNG,
+			 0x410F),
+	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_SAMSUNG,
+			 0xC706),
+	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_SAMSUNG,
+			 0xC680),
+	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_SAMSUNG,
+			 0xC708),
+	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_LENOVO,
+			 0x3218),
+	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_LENOVO,
+			 0x3219),
+	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
+
 	{ PCI_VDEVICE(ATHEROS, 0x0032) }, /* PCI-E  AR9485 */
 	{ PCI_VDEVICE(ATHEROS, 0x0033) }, /* PCI-E  AR9580 */
 
-- 
1.8.3.4

