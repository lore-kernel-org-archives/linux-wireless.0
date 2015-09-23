Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:36023 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbbIWJEO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 05:04:14 -0400
Received: by pacgz1 with SMTP id gz1so1191521pac.3
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2015 02:04:13 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 6/6] staging: wilc1000: delete wilc_oswrapper.h
Date: Wed, 23 Sep 2015 18:03:50 +0900
Message-Id: <1442999030-31934-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20150923_110421_926027_0C0007C7)
In-Reply-To: <1442999030-31934-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442999030-31934-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch delete wilc_oswrapper.h that has nothing inside.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_oswrapper.h | 16 ----------------
 drivers/staging/wilc1000/wilc_wlan.h      |  1 -
 drivers/staging/wilc1000/wilc_wlan_if.h   |  1 -
 3 files changed, 18 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/wilc_oswrapper.h

diff --git a/drivers/staging/wilc1000/wilc_oswrapper.h b/drivers/staging/wilc1000/wilc_oswrapper.h
deleted file mode 100644
index 10d16e9..0000000
--- a/drivers/staging/wilc1000/wilc_oswrapper.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifndef __WILC_OSWRAPPER_H__
-#define __WILC_OSWRAPPER_H__
-
-/*!
- *  @file	wilc_oswrapper.h
- *  @brief	Top level OS Wrapper, include this file and it will include all
- *              other files as necessary
- *  @author	syounan
- *  @date	10 Aug 2010
- *  @version	1.0
- */
-
-
-
-
-#endif
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 60da18c..ad8de29 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -1,7 +1,6 @@
 #ifndef WILC_WLAN_H
 #define WILC_WLAN_H
 
-#include "wilc_oswrapper.h"
 
 
 #define ISWILC1000(id)   (((id & 0xfffff000) == 0x100000) ? 1 : 0)
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index fd37997..f561eac 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -15,7 +15,6 @@
 /* #define USE_OLD_SPI_SW */
 
 #include <linux/semaphore.h>
-#include "wilc_oswrapper.h"
 #include "linux_wlan_common.h"
 
 
-- 
2.5.1

