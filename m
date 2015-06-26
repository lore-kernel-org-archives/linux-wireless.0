Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:34325 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbbFZGtI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 02:49:08 -0400
Received: by pdbep18 with SMTP id ep18so47431339pdb.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2015 23:49:08 -0700 (PDT)
From: Sunghoon Cho <ywhsbliss@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, Rachel.kim@atmel.com,
	dean.lee@atmel.com, ywhsbliss@gmail.com
Subject: [PATCH 1/3] staging: wilc1000: remove the warnings on the prohibited spaces
Date: Fri, 26 Jun 2015 15:48:14 +0900
Message-Id: <41da67d312f5ddf70e2a401814df494d71c8a945.1435300603.git.ywhsbliss@gmail.com> (sfid-20150626_084915_195817_136CDB15)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the warnings reported by checkpatch.pl regarding
prohibited spaces between function name and open parenthesis.

Signed-off-by: Sunghoon Cho <ywhsbliss@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index d413fa3..22d7b85 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -80,9 +80,9 @@ struct WILC_WFI_stats {
  * LPC3131 which is important to get the MAC start status when you are blocked inside
  * linux_wlan_firmware_download() which blocks mac_open().
  */
-#if defined (NM73131_0_BOARD)
+#if defined(NM73131_0_BOARD)
  #define RX_BH_TYPE  RX_BH_KTHREAD
-#elif defined (PANDA_BOARD)
+#elif defined(PANDA_BOARD)
  #define RX_BH_TYPE  RX_BH_THREADED_IRQ
 #else
  #define RX_BH_TYPE  RX_BH_KTHREAD
-- 
1.9.1

