Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340Ab3B1Itd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 03:49:33 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/2] ath5k: remove reference to napi_poll
Date: Thu, 28 Feb 2013 09:49:12 +0100
Message-Id: <1362041352-13110-2-git-send-email-sgruszka@redhat.com> (sfid-20130228_094935_367168_4E07AD12)
In-Reply-To: <1362041352-13110-1-git-send-email-sgruszka@redhat.com>
References: <1362041352-13110-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ath/ath5k/mac80211-ops.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 4264341..7604d6d 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -821,7 +821,6 @@ const struct ieee80211_ops ath5k_hw_ops = {
 	/* .rfkill_poll		= not implemented */
 	/* .flush		= not implemented */
 	/* .channel_switch	= not implemented */
-	/* .napi_poll		= not implemented */
 	.set_antenna		= ath5k_set_antenna,
 	.get_antenna		= ath5k_get_antenna,
 	.set_ringparam		= ath5k_set_ringparam,
-- 
1.7.11.7

