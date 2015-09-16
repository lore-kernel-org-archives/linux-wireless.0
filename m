Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33447 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbbIPLMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 07:12:00 -0400
Received: by pacex6 with SMTP id ex6so207194857pac.0
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2015 04:12:00 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 07/10] staging: wilc1000: remove unused defines
Date: Wed, 16 Sep 2015 20:11:32 +0900
Message-Id: <1442401895-7463-7-git-send-email-chaehyun.lim@gmail.com> (sfid-20150916_131245_944405_582A25CF)
In-Reply-To: <1442401895-7463-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442401895-7463-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused defines.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
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

