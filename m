Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46026 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab2KAFur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2012 01:50:47 -0400
Received: by mail-qc0-f174.google.com with SMTP id o22so1496222qcr.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2012 22:50:46 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 1 Nov 2012 13:50:46 +0800
Message-ID: <CAPgLHd9LSvsQyQTvnVsufNLcR3h21iNCmHud34UNjCvw8_3oBw@mail.gmail.com> (sfid-20121101_065101_354668_98F22504)
Subject: [PATCH -next] brcmfmac: remove duplicated include from dhd_dbg.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: brudley@broadcom.com, rvossen@broadcom.com, arend@broadcom.com,
	kanyan@broadcom.com, frankyl@broadcom.com, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
index 862d2ac..49f53ba 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
@@ -19,7 +19,6 @@
 #include <linux/netdevice.h>
 #include <linux/ieee80211.h>
 #include <linux/module.h>
-#include <linux/netdevice.h>
 
 #include <defs.h>
 #include <brcmu_wifi.h>


