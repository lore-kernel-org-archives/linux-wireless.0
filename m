Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36815 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbbIUM7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 08:59:18 -0400
Received: by padbj2 with SMTP id bj2so6764475pad.3
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2015 05:59:18 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 15/16] staging: wilc1000: host_int_init: remove blank line before a close brace.
Date: Mon, 21 Sep 2015 21:58:25 +0900
Message-Id: <1442840306-9657-15-git-send-email-chaehyun.lim@gmail.com> (sfid-20150921_145922_081707_C9C592C2)
In-Reply-To: <1442840306-9657-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442840306-9657-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes blank line before a close brace.
CHECK: Blank lines aren't necessary before a close brace '}'

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
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

