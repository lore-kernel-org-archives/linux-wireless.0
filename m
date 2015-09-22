Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34468 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbbIVJfu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 05:35:50 -0400
Received: by padhy16 with SMTP id hy16so4762534pad.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2015 02:35:49 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH V2 15/16] staging: wilc1000: host_int_init: remove blank line before a close brace.
Date: Tue, 22 Sep 2015 18:35:00 +0900
Message-Id: <1442914501-2315-15-git-send-email-chaehyun.lim@gmail.com> (sfid-20150922_114655_352938_4E81DF25)
In-Reply-To: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442914501-2315-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes blank line before a close brace.
CHECK: Blank lines aren't necessary before a close brace '}'

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
v2: rebase latest staging-testing

 drivers/staging/wilc1000/host_interface.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ee4f169..82db248 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -6463,7 +6463,6 @@ _fail_mq_:
 	wilc_mq_destroy(&gMsgQHostIF);
 _fail_:
 	return result;
-
 }
 /**
  *  @brief              host_int_deinit
-- 
2.5.1

