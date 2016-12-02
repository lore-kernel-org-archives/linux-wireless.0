Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34393 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755187AbcLBBs4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 20:48:56 -0500
Received: by mail-oi0-f67.google.com with SMTP id m75so25565095oig.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2016 17:48:56 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 11/14] rtlwifi: Add a new enumeration value to btc_set_type
Date: Thu,  1 Dec 2016 19:48:30 -0600
Message-Id: <20161202014833.6856-12-Larry.Finger@lwfinger.net> (sfid-20161202_024910_603298_ACC1EA5F)
In-Reply-To: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
References: <20161202014833.6856-1-Larry.Finger@lwfinger.net>
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
index 190826f..d4da3a1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
@@ -286,6 +286,7 @@ enum btc_set_type {
 	/* type trigger some action */
 	BTC_SET_ACT_GET_BT_RSSI,
 	BTC_SET_ACT_AGGREGATE_CTRL,
+	BTC_SET_ACT_ANTPOSREGRISTRY_CTRL,
 
 	/********* for 1Ant **********/
 	/* type bool */
-- 
2.10.2
