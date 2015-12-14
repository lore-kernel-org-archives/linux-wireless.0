Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:35676 "EHLO
	mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932898AbbLNWfB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 17:35:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH 5/8] rtlwifi: rtl8192de: Fix incorrect module parameter descriptions
Date: Mon, 14 Dec 2015 16:34:35 -0600
Message-Id: <1450132478-2386-6-git-send-email-Larry.Finger@lwfinger.net> (sfid-20151214_233509_181895_806C00FE)
In-Reply-To: <1450132478-2386-2-git-send-email-Larry.Finger@lwfinger.net>
References: <1450132478-2386-2-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two of the module parameters are listed with incorrect default values.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
index b19d039..c6e09a1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
@@ -376,8 +376,8 @@ module_param_named(swlps, rtl92de_mod_params.swctrl_lps, bool, 0444);
 module_param_named(fwlps, rtl92de_mod_params.fwctrl_lps, bool, 0444);
 MODULE_PARM_DESC(swenc, "Set to 1 for software crypto (default 0)\n");
 MODULE_PARM_DESC(ips, "Set to 0 to not use link power save (default 1)\n");
-MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 0)\n");
-MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
+MODULE_PARM_DESC(swlps, "Set to 1 to use SW control power save (default 1)\n");
+MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 0)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
 
 static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
-- 
2.1.4

