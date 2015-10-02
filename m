Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33752 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbbJBHl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 03:41:29 -0400
Received: by pacex6 with SMTP id ex6so100061377pac.0
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2015 00:41:29 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 01/12] staging: wilc1000: remove wilc_platform.h
Date: Fri,  2 Oct 2015 16:41:10 +0900
Message-Id: <1443771681-15540-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20151002_094132_698886_727664A8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes wilc_platform.h file that is not used anywhere.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2: resend because 08/12 patch is changed.

 drivers/staging/wilc1000/wilc_platform.h | 28 ----------------------------
 1 file changed, 28 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/wilc_platform.h

diff --git a/drivers/staging/wilc1000/wilc_platform.h b/drivers/staging/wilc1000/wilc_platform.h
deleted file mode 100644
index 6ec1aa3..0000000
--- a/drivers/staging/wilc1000/wilc_platform.h
+++ /dev/null
@@ -1,28 +0,0 @@
-#ifndef __WILC_platform_H__
-#define __WILC_platform_H__
-
-#include <linux/kthread.h>
-#include <linux/semaphore.h>
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/types.h>
-#include <linux/stat.h>
-#include <linux/time.h>
-#include <linux/version.h>
-#include "linux/string.h"
-/******************************************************************
- *      OS specific types
- *******************************************************************/
-
-
-
-
-
-
-/*******************************************************************
- *      others
- ********************************************************************/
-
-#endif
-- 
2.6.0

