Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:38502 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752069AbeCFB0P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 20:26:15 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 13/15] rtlwifi: btcoex: Add 8822b header files to precomp.h
Date: Tue, 6 Mar 2018 09:25:52 +0800
Message-ID: <20180306012554.3108-14-pkshih@realtek.com> (sfid-20180306_022621_082773_2C53E2AD)
In-Reply-To: <20180306012554.3108-1-pkshih@realtek.com>
References: <20180306012554.3108-1-pkshih@realtek.com>
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
