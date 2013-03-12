Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:54018 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab3CLDJg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 23:09:36 -0400
Received: by mail-bk0-f50.google.com with SMTP id jg9so1972636bkc.23
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2013 20:09:34 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 12 Mar 2013 11:09:34 +0800
Message-ID: <CAPgLHd-2Xp9e4WfhaxDdj5JDW48bKgpu_6nHsJ-iNepNJuzJzg@mail.gmail.com> (sfid-20130312_040938_563671_8801D0EA)
Subject: [PATCH -next v2] wil6210: remove unused including <linux/version.h>
From: Wei Yongjun <weiyj.lk@gmail.com>
To: qca_vkondrat@qca.qualcomm.com, linville@tuxdriver.com,
	Larry.Finger@lwfinger.net
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	wil6210@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove including <linux/version.h> that don't need it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
v1 -> v2: fix subject
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


