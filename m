Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34249 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752049AbdATV1Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 16:27:25 -0500
Received: by mail-oi0-f68.google.com with SMTP id w144so6503854oiw.1
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2017 13:27:25 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 03/11] rtlwifi: Add a new enumeration value to btc_set_type
Date: Fri, 20 Jan 2017 15:27:08 -0600
Message-Id: <20170120212716.29887-4-Larry.Finger@lwfinger.net> (sfid-20170120_223043_118377_F0396FD4)
In-Reply-To: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

The new value is needed for future capability.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
index 3d308eb..eb89011 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -263,6 +263,7 @@ enum btc_set_type {
 	/* type trigger some action */
 	BTC_SET_ACT_GET_BT_RSSI,
 	BTC_SET_ACT_AGGREGATE_CTRL,
+	BTC_SET_ACT_ANTPOSREGRISTRY_CTRL,
 
 	/********* for 1Ant **********/
 	/* type bool */
-- 
2.10.2
