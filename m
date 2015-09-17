Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36473 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbbIQHtM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 03:49:12 -0400
Received: by padhk3 with SMTP id hk3so13295593pad.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2015 00:49:12 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 6/8] staging: wilc1000: remove WILC_TIME typedef
Date: Thu, 17 Sep 2015 16:48:47 +0900
Message-Id: <1442476129-14908-6-git-send-email-chaehyun.lim@gmail.com> (sfid-20150917_094916_325436_FAB56A4A)
In-Reply-To: <1442476129-14908-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442476129-14908-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes WILC_TIME typedef that is not used anymore.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
V2 : rebase latest staging-testing

 drivers/staging/wilc1000/wilc_platform.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_platform.h b/drivers/staging/wilc1000/wilc_platform.h
index 5c867ec..b763616 100644
--- a/drivers/staging/wilc1000/wilc_platform.h
+++ b/drivers/staging/wilc1000/wilc_platform.h
@@ -33,8 +33,6 @@ typedef struct __MessageQueue_struct {
 
 
 
-/*Time represented in 64 bit format*/
-typedef time_t WILC_Time;
 
 
 /*******************************************************************
-- 
2.5.1

