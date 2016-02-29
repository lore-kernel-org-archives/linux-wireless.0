Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbcB2WFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:53 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 004/113] rtl8xxxu: Add rtl8192eu_nic.bin to the MODULE_FIRMWARE list
Date: Mon, 29 Feb 2016 17:04:02 -0500
Message-Id: <1456783551-28315-5-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230557_787177_A82D1998)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 8ef72e3..5413e35 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -54,6 +54,7 @@ MODULE_FIRMWARE("rtlwifi/rtl8723aufw_B_NoBT.bin");
 MODULE_FIRMWARE("rtlwifi/rtl8192cufw_A.bin");
 MODULE_FIRMWARE("rtlwifi/rtl8192cufw_B.bin");
 MODULE_FIRMWARE("rtlwifi/rtl8192cufw_TMSC.bin");
+MODULE_FIRMWARE("rtlwifi/rtl8192eu_nic.bin");
 
 module_param_named(debug, rtl8xxxu_debug, int, 0600);
 MODULE_PARM_DESC(debug, "Set debug mask");
-- 
2.5.0

