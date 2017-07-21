Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36288 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750728AbdGUEYu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 00:24:50 -0400
Received: by mail-oi0-f67.google.com with SMTP id c135so3403525oih.3
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jul 2017 21:24:49 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 01/10] rtlwifi: Add COMP_HALMAC to debug
Date: Thu, 20 Jul 2017 23:24:31 -0500
Message-Id: <20170721042440.15839-2-Larry.Finger@lwfinger.net> (sfid-20170721_062504_569558_CA54E817)
In-Reply-To: <20170721042440.15839-1-Larry.Finger@lwfinger.net>
References: <20170721042440.15839-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add a debug component ID for halmac

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/debug.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.h b/drivers/net/wireless/realtek/rtlwifi/debug.h
index ad6834af618b..4840f8801ec0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.h
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.h
@@ -106,6 +106,7 @@
 #define COMP_BT_COEXIST			BIT(30)
 #define COMP_IQK			BIT(31)
 #define COMP_TX_REPORT			BIT_ULL(32)
+#define COMP_HALMAC			BIT_ULL(34)
 
 /*--------------------------------------------------------------
 		Define the rt_print components
-- 
2.12.3
