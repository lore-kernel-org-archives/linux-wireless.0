Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23613 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab0DAEn2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 00:43:28 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 31 Mar 2010 21:43:28 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19380.10545.555944.300381@gargle.gargle.HOWL>
Date: Thu, 1 Apr 2010 10:33:45 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] ath9k_htc: Add TL-WN422G v2 product ID
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index e584a29..3afc747 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -21,6 +21,7 @@
 
 static struct usb_device_id ath9k_hif_usb_ids[] = {
 	ATH9K_FW_USB_DEV(0x9271, "ar9271.fw"),
+	ATH9K_FW_USB_DEV(0x1006, "ar9271.fw"),
 	{ },
 };
 
-- 
1.7.0.3

