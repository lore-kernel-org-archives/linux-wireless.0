Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:33415 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbbCFPrf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 10:47:35 -0500
Received: by pdev10 with SMTP id v10so29504849pde.0
        for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2015 07:47:35 -0800 (PST)
From: Taehee Yoo <ap420073@gmail.com>
To: Larry.Finger@lwfinger.net, ap420073@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Remove duplicated prototype
Date: Sat,  7 Mar 2015 00:47:17 +0900
Message-Id: <1425656837-13879-1-git-send-email-ap420073@gmail.com> (sfid-20150306_164739_095644_A8819ACC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove duplicated prototype in base.h

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/rtlwifi/base.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/base.h b/drivers/net/wireless/rtlwifi/base.h
index dee4ac2..ff9a4bf 100644
--- a/drivers/net/wireless/rtlwifi/base.h
+++ b/drivers/net/wireless/rtlwifi/base.h
@@ -123,7 +123,6 @@ bool rtl_tx_mgmt_proc(struct ieee80211_hw *hw, struct sk_buff *skb);
 u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx);
 
 void rtl_beacon_statistic(struct ieee80211_hw *hw, struct sk_buff *skb);
-void rtl_watch_dog_timer_callback(unsigned long data);
 int rtl_tx_agg_start(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 int rtl_tx_agg_stop(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-- 
1.9.1

