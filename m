Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:29316 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbbCRSkn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 14:40:43 -0400
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath10k: enable channel 144 on 5GHz band
Date: Wed, 18 Mar 2015 11:39:18 -0700
Message-ID: <1426703958-8005-1-git-send-email-poh@qca.qualcomm.com> (sfid-20150318_194051_840369_E47B96B9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable channel 144 on 5GHz band since 802.11ac introduced it.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 341f3c8..56de3dc 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5480,6 +5480,7 @@ static const struct ieee80211_channel ath10k_5ghz_channels[] = {
 	CHAN5G(132, 5660, 0),
 	CHAN5G(136, 5680, 0),
 	CHAN5G(140, 5700, 0),
+	CHAN5G(144, 5720, 0),
 	CHAN5G(149, 5745, 0),
 	CHAN5G(153, 5765, 0),
 	CHAN5G(157, 5785, 0),
-- 
1.9.1

