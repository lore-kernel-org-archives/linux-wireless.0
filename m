Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34351 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbbIOFHd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:07:33 -0400
Received: by padhy16 with SMTP id hy16so164916626pad.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 22:07:33 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 14/18] staging: wilc1000: remove USE_SUPPLICANT_GO_INTENT
Date: Tue, 15 Sep 2015 14:06:24 +0900
Message-Id: <1442293588-15323-14-git-send-email-chaehyun.lim@gmail.com> (sfid-20150915_070744_358081_C43458D1)
In-Reply-To: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes USE_SUPPLICANT_GO_INTENT macro that is commented.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index edf5ec0..aac9e3f 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -21,7 +21,6 @@
 #define TKIP			BIT(6)
 
 #ifdef WILC_P2P
-/* #define	USE_SUPPLICANT_GO_INTENT */
 
 /*Public action frame index IDs*/
 #define		FRAME_TYPE_ID					0
-- 
2.5.1

