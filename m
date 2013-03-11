Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:42055 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3CKOqD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 10:46:03 -0400
Received: by mail-bk0-f41.google.com with SMTP id q16so1724111bkw.14
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2013 07:46:02 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 11 Mar 2013 22:46:02 +0800
Message-ID: <CAPgLHd-Pn9c_FL7v1FYCb8NCP4GdJPuEB-eMSWXiWK5bd8dwVQ@mail.gmail.com> (sfid-20130311_154608_456545_B8953A51)
Subject: [PATCH -next] wireless: remove unused including <linux/version.h>
From: Wei Yongjun <weiyj.lk@gmail.com>
To: qca_vkondrat@qca.qualcomm.com, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	wil6210@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove including <linux/version.h> that don't need it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 116f4e8..58ce52c 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -21,7 +21,6 @@
 #include <linux/wireless.h>
 #include <linux/ieee80211.h>
 #include <linux/slab.h>
-#include <linux/version.h>
 #include <net/cfg80211.h>
 
 #include "wil6210.h"


