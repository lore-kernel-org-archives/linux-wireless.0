Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61644 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3E3LlO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 May 2013 07:41:14 -0400
Received: by mail-bk0-f46.google.com with SMTP id na10so82323bkb.33
        for <linux-wireless@vger.kernel.org>; Thu, 30 May 2013 04:41:12 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 30 May 2013 19:41:11 +0800
Message-ID: <CAPgLHd_=MWYEYniddEJNBJGDBJyoDC1S2HV+Pnn1GugwM+PQgg@mail.gmail.com> (sfid-20130530_134122_653068_83D2C0A3)
Subject: [PATCH -next] cw1200: remove duplicated include from wsm.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: pizza@shaftnet.org, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/cw1200/wsm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/cw1200/wsm.c b/drivers/net/wireless/cw1200/wsm.c
index 4db6cc1..f3fd9b2 100644
--- a/drivers/net/wireless/cw1200/wsm.c
+++ b/drivers/net/wireless/cw1200/wsm.c
@@ -12,7 +12,6 @@
 
 #include <linux/skbuff.h>
 #include <linux/wait.h>
-#include <linux/skbuff.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/random.h>

