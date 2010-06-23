Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44156 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab0FWSaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 14:30:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@atheros.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] ath9k: declare MODULE_FIRMWARE for ath9k_htc
Date: Wed, 23 Jun 2010 14:23:13 -0400
Message-Id: <1277317393-20245-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 74bc80f..4949f83 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -16,6 +16,11 @@
 
 #include "htc.h"
 
+/* identify firmware images */
+MODULE_FIRMWARE("ar7010.fw");
+MODULE_FIRMWARE("ar7010_1_1.fw");
+MODULE_FIRMWARE("ar9271.fw");
+
 static struct usb_device_id ath9k_hif_usb_ids[] = {
 	{ USB_DEVICE(0x0cf3, 0x9271) }, /* Atheros */
 	{ USB_DEVICE(0x0cf3, 0x1006) }, /* Atheros */
-- 
1.7.0.1

