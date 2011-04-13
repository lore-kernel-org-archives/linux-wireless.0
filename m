Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48067 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab1DMFuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:50:18 -0400
Received: by iyb14 with SMTP id 14so274186iyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:50:18 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.14890.766362.879019@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:22:42 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 02/40] ath9k_htc: Rename firmware
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Since the new FW requires backward incompatible host driver changes,
rename the FW to allow older driver versions to work with the
older FW.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index dc05820..c81b2da 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -17,8 +17,8 @@
 #include "htc.h"
 
 /* identify firmware images */
-#define FIRMWARE_AR7010_1_1	"ar7010_1_1.fw"
-#define FIRMWARE_AR9271		"ar9271.fw"
+#define FIRMWARE_AR7010_1_1     "htc_7010.fw"
+#define FIRMWARE_AR9271         "htc_9271.fw"
 
 MODULE_FIRMWARE(FIRMWARE_AR7010_1_1);
 MODULE_FIRMWARE(FIRMWARE_AR9271);
-- 
1.7.4.4

