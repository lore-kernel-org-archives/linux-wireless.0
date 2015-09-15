Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33997 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbbIOFHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:07:15 -0400
Received: by padhy16 with SMTP id hy16so164908319pad.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 22:07:14 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 08/18] staging: wilc1000: remove useless extern declarations
Date: Tue, 15 Sep 2015 14:06:18 +0900
Message-Id: <1442293588-15323-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20150915_070733_408246_F15F92DE)
In-Reply-To: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442293588-15323-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes useless extern declarations. This function is not
existed in the driver.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 59327aa..960950c 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1,8 +1,6 @@
 #include "host_interface.h"
 #include "coreconfigurator.h"
 
-extern s32 TransportInit(void);
-extern s32 TransportDeInit(void);
 extern u8 connecting;
 
 #ifdef DISABLE_PWRSAVE_AND_SCAN_DURING_IP
-- 
2.5.1

