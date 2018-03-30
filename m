Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:34468 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752431AbeC3HTl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Mar 2018 03:19:41 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 02/17] rtlwifi: add debug ID COMP_HALMAC
Date: Fri, 30 Mar 2018 15:19:01 +0800
Message-ID: <20180330071916.23360-3-pkshih@realtek.com> (sfid-20180330_091952_953484_D08981FE)
In-Reply-To: <20180330071916.23360-1-pkshih@realtek.com>
References: <20180330071916.23360-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add a debug ID for the module halmac

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/debug.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.h b/drivers/net/wireless/realtek/rtlwifi/debug.h
index ad6834af618b..90c41c17d678 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.h
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.h
@@ -106,6 +106,7 @@
 #define COMP_BT_COEXIST			BIT(30)
 #define COMP_IQK			BIT(31)
 #define COMP_TX_REPORT			BIT_ULL(32)
+#define COMP_HALMAC			BIT_ULL(33)
 
 /*--------------------------------------------------------------
 		Define the rt_print components
-- 
2.15.1
