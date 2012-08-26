Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:60986 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab2HZBpV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Aug 2012 21:45:21 -0400
MIME-Version: 1.0
Date: Sun, 26 Aug 2012 09:45:21 +0800
Message-ID: <CAPgLHd-Y2voCSSGdbxm4R2AH=fqN+CP2PQVJ5vT1Y-QLNNFTjw@mail.gmail.com> (sfid-20120826_034531_265994_CF6DB032)
Subject: [PATCH] wl18xx: remove duplicated include from main.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: coelho@ti.com, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/ti/wl18xx/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 69042bb..31cf6eb 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -30,7 +30,6 @@
 #include "../wlcore/acx.h"
 #include "../wlcore/tx.h"
 #include "../wlcore/rx.h"
-#include "../wlcore/io.h"
 #include "../wlcore/boot.h"
 
 #include "reg.h"

