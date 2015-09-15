Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35084 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbbIOFGx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:06:53 -0400
Received: by pacfv12 with SMTP id fv12so168220296pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 22:06:53 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 01/18] staging: wilc1000: remove duplicated include
Date: Tue, 15 Sep 2015 14:06:11 +0900
Message-Id: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150915_070723_736350_C5A7DF77)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wilc_wfi_cfgoperations.h and linux_wlan_common.h are included as
duplicated in linux_wlan.c.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 63f44f8..2f609f0 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2,9 +2,6 @@
 #include "linux_wlan_common.h"
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
-#include "wilc_wfi_cfgoperations.h"
-
-#include "linux_wlan_common.h"
 
 #include <linux/slab.h>
 #include <linux/sched.h>
-- 
2.5.1

