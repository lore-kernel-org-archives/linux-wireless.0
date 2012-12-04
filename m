Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:42147 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab2LDIaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 03:30:21 -0500
Received: by mail-qa0-f53.google.com with SMTP id a19so504764qad.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Dec 2012 00:30:20 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 4 Dec 2012 03:30:20 -0500
Message-ID: <CAPgLHd_sFMFXRLBUmoKS73VhTSRfn84R=03aPN5WgF20jPFfPw@mail.gmail.com> (sfid-20121204_093024_889279_1994B496)
Subject: [PATCH -next] brcmsmac: remove duplicated include from debug.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: brudley@broadcom.com, arend@broadcom.com, meuleman@broadcom.com,
	linville@tuxdriver.com, frankyl@broadcom.com, phaber@broadcom.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/brcm80211/brcmsmac/debug.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/debug.c b/drivers/net/wireless/brcm80211/brcmsmac/debug.c
index be84791..9761deb 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/debug.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/debug.c
@@ -21,7 +21,6 @@
 #include <linux/netdevice.h>
 #include <linux/ieee80211.h>
 #include <linux/module.h>
-#include <linux/netdevice.h>
 #include <net/mac80211.h>
 
 #include <defs.h>


