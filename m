Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33726 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757565AbbFQFnD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 01:43:03 -0400
Received: by padev16 with SMTP id ev16so27152745pad.0
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2015 22:43:03 -0700 (PDT)
From: Sunghoon Cho <ywhsbliss@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	chris.park@atmel.com, Rachel.kim@atmel.com, dean.lee@atmel.com
Cc: Sunghoon Cho <ywhsbliss@gmail.com>
Subject: [PATCH 4/5] staging: wilc1000: remove prohibited spaces.
Date: Wed, 17 Jun 2015 14:42:35 +0900
Message-Id: <0d07f1a77b401c709fb8ae4be248f5e27b20e688.1434519635.git.ywhsbliss@gmail.com> (sfid-20150617_074307_335503_2A56B110)
In-Reply-To: <99c95a41549a43582fd1c679c34723d54771cbcc.1434519635.git.ywhsbliss@gmail.com>
References: <99c95a41549a43582fd1c679c34723d54771cbcc.1434519635.git.ywhsbliss@gmail.com>
In-Reply-To: <99c95a41549a43582fd1c679c34723d54771cbcc.1434519635.git.ywhsbliss@gmail.com>
References: <99c95a41549a43582fd1c679c34723d54771cbcc.1434519635.git.ywhsbliss@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the warnings on the prohibited spaces between
function name and open parenthesis.

Signed-off-by: Sunghoon Cho <ywhsbliss@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 96e4d5c..3307439 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -80,9 +80,9 @@ struct WILC_WFI_stats {
  * LPC3131 which is important to get the MAC start status when you are blocked
  * inside linux_wlan_firmware_download() which blocks mac_open().
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

