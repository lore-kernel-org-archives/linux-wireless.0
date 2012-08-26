Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:39957 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2HZBrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Aug 2012 21:47:07 -0400
MIME-Version: 1.0
Date: Sun, 26 Aug 2012 09:47:06 +0800
Message-ID: <CAPgLHd8myDxwLUgB+nqXZM3KG3xvsqidXH17xEKi-XqdBieeNg@mail.gmail.com> (sfid-20120826_034711_242963_B6B9DCB7)
Subject: wl12xx: remove duplicated include from main.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: coelho@ti.com, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/ti/wl12xx/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index f429fc1..284adec 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -32,7 +32,6 @@
 #include "../wlcore/acx.h"
 #include "../wlcore/tx.h"
 #include "../wlcore/rx.h"
-#include "../wlcore/io.h"
 #include "../wlcore/boot.h"
 
 #include "wl12xx.h"


