Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36820 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbbIOFHj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:07:39 -0400
Received: by padhk3 with SMTP id hk3so164832667pad.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 22:07:39 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 16/18] staging: wilc1000: remove FORCE_P2P_CLIENT
Date: Tue, 15 Sep 2015 14:06:26 +0900
Message-Id: <1442293588-15323-16-git-send-email-chaehyun.lim@gmail.com> (sfid-20150915_071653_068945_9AF09FA7)
In-Reply-To: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes FORCE_P2P_CLIENT that is commented.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 15510f2..28858da 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -47,7 +47,6 @@
 #define		GAS_INTIAL_RSP					0x0b
 
 #define		INVALID_CHANNEL					0
-/* #define FORCE_P2P_CLIENT */
 #endif
 
 #define nl80211_SCAN_RESULT_EXPIRE	(3 * HZ)
-- 
2.5.1

