Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36112 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbbHQNom (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 09:44:42 -0400
Received: by pawq9 with SMTP id q9so11366848paw.3
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2015 06:44:42 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 2/4] staging: wilc1000: delete wilc_osconfig.h
Date: Mon, 17 Aug 2015 22:44:29 +0900
Message-Id: <1439819071-30000-2-git-send-email-chaehyun.lim@gmail.com> (sfid-20150817_154445_489213_2B1CEFF6)
In-Reply-To: <1439819071-30000-1-git-send-email-chaehyun.lim@gmail.com>
References: <1439819071-30000-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The macros inside wilc_osconfig.h are not referenced anywhere,
so just delete it.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_osconfig.h  | 9 ---------
 drivers/staging/wilc1000/wilc_oswrapper.h | 1 -
 2 files changed, 10 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/wilc_osconfig.h

diff --git a/drivers/staging/wilc1000/wilc_osconfig.h b/drivers/staging/wilc1000/wilc_osconfig.h
deleted file mode 100644
index f9c2514..0000000
--- a/drivers/staging/wilc1000/wilc_osconfig.h
+++ /dev/null
@@ -1,9 +0,0 @@
-/* Logs options */
-#define WILC_LOGS_NOTHING          0
-#define WILC_LOGS_WARN             1
-#define WILC_LOGS_WARN_INFO        2
-#define WILC_LOGS_WARN_INFO_DBG    3
-#define WILC_LOGS_WARN_INFO_DBG_FN 4
-#define WILC_LOGS_ALL              5
-
-#define WILC_LOG_VERBOSITY_LEVEL WILC_LOGS_ALL
diff --git a/drivers/staging/wilc1000/wilc_oswrapper.h b/drivers/staging/wilc1000/wilc_oswrapper.h
index 68e091f..45df626 100644
--- a/drivers/staging/wilc1000/wilc_oswrapper.h
+++ b/drivers/staging/wilc1000/wilc_oswrapper.h
@@ -14,7 +14,6 @@
 #define WILC_OSW_INTERFACE_VER 2
 
 /* Os Configuration File */
-#include "wilc_osconfig.h"
 #include "wilc_platform.h"
 
 
-- 
1.9.1

