Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:42540 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750960AbeDMGQi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 02:16:38 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v4 3/9] rtlwifi: btcoex: Add 8822b header files to precomp.h
Date: Fri, 13 Apr 2018 14:16:07 +0800
Message-ID: <20180413061613.8569-4-pkshih@realtek.com> (sfid-20180413_081643_886354_0F232570)
In-Reply-To: <20180413061613.8569-1-pkshih@realtek.com>
References: <20180413061613.8569-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add 8822b header files to precomp.h for routing functions.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
index 02dff4c3f664..858318fd3d63 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
@@ -48,6 +48,9 @@
 #include "halbtc8723b2ant.h"
 #include "halbtc8821a2ant.h"
 #include "halbtc8821a1ant.h"
+#include "halbtc8822b1ant.h"
+#include "halbtc8822b2ant.h"
+#include "halbtc8822bwifionly.h"
 
 #define GetDefaultAdapter(padapter)	padapter
 
-- 
2.15.1
