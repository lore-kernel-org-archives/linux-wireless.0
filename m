Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:39532 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753054AbeASGqX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 01:46:23 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/10] rtlwifi: btcoex: add boolean variables dbg_mode
Date: Fri, 19 Jan 2018 14:45:47 +0800
Message-ID: <20180119064551.10084-7-pkshih@realtek.com> (sfid-20180119_074631_348012_1D7A00EC)
In-Reply-To: <20180119064551.10084-1-pkshih@realtek.com>
References: <20180119064551.10084-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

In files halbtc8822b1ant.c and halbtc8822b2ant.c that I will submit later,
two undesired directives named BT_8822B_1ANT_COEX_DBG and
BT_8822B_2ANT_COEX_DBG will be replaced by boolean variables.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index 6c145313c615..1c6019be793a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -583,6 +583,8 @@ struct btc_coexist {
 	 */
 	bool auto_report_1ant;
 	bool auto_report_2ant;
+	bool dbg_mode_1ant;
+	bool dbg_mode_2ant;
 	bool initilized;
 	bool stop_coex_dm;
 	bool manual_control;
-- 
2.15.1
