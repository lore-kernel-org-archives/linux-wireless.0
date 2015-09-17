Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35579 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839AbbIQHtJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 03:49:09 -0400
Received: by pacfv12 with SMTP id fv12so13602939pac.2
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2015 00:49:09 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 5/8] staging: wilc1000: remove unused defines
Date: Thu, 17 Sep 2015 16:48:46 +0900
Message-Id: <1442476129-14908-5-git-send-email-chaehyun.lim@gmail.com> (sfid-20150917_094913_278661_66711A5B)
In-Reply-To: <1442476129-14908-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442476129-14908-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused defines.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2 : rebase latest staging-testing

 drivers/staging/wilc1000/wilc_platform.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_platform.h b/drivers/staging/wilc1000/wilc_platform.h
index 1e56973..5c867ec 100644
--- a/drivers/staging/wilc1000/wilc_platform.h
+++ b/drivers/staging/wilc1000/wilc_platform.h
@@ -41,8 +41,4 @@ typedef time_t WILC_Time;
  *      others
  ********************************************************************/
 
-/* Generic printf function */
-#define __WILC_FILE__		__FILE__
-#define __WILC_FUNCTION__	__func__
-#define __WILC_LINE__		__LINE__
 #endif
-- 
2.5.1

