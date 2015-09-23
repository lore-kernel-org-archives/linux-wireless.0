Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35900 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbbIWJEH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 05:04:07 -0400
Received: by pacgz1 with SMTP id gz1so1188689pac.3
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2015 02:04:06 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 4/6] staging: wilc1000: remove WILC_OSW_INTERFACE_VER define
Date: Wed, 23 Sep 2015 18:03:48 +0900
Message-Id: <1442999030-31934-4-git-send-email-chaehyun.lim@gmail.com> (sfid-20150923_110417_973374_AEC33F5A)
In-Reply-To: <1442999030-31934-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442999030-31934-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes WILC_OSW_INTERFACE_VER define that is not used
anywhere.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_oswrapper.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_oswrapper.h b/drivers/staging/wilc1000/wilc_oswrapper.h
index 4f7bd89..5456c96 100644
--- a/drivers/staging/wilc1000/wilc_oswrapper.h
+++ b/drivers/staging/wilc1000/wilc_oswrapper.h
@@ -10,8 +10,6 @@
  *  @version	1.0
  */
 
-/* OS Wrapper interface version */
-#define WILC_OSW_INTERFACE_VER 2
 
 /* Os Configuration File */
 #include "wilc_platform.h"
-- 
2.5.1

