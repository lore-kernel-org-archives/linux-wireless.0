Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:65535 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab3FFDpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 23:45:43 -0400
Received: by mail-pd0-f179.google.com with SMTP id q11so2741277pdj.38
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 20:45:42 -0700 (PDT)
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	kvalo@qca.qualcomm.com
Subject: [PATCH] ath: add VHT80 support for regulatory domains
Date: Wed,  5 Jun 2013 20:45:36 -0700
Message-Id: <1370490336-12160-1-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20130606_054546_346355_C29D0CD7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

This adds VHT80 support for the QCA world regulatory
domains.

Cc: kvalo@qca.qualcomm.com
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/regd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index ccc4c71..7d077c7 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -42,11 +42,11 @@ static int __ath_regd_init(struct ath_regulatory *reg);
 				NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_OFDM)
 
 /* We allow IBSS on these on a case by case basis by regulatory domain */
-#define ATH9K_5GHZ_5150_5350	REG_RULE(5150-10, 5350+10, 40, 0, 30,\
+#define ATH9K_5GHZ_5150_5350	REG_RULE(5150-10, 5350+10, 80, 0, 30,\
 				NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS)
-#define ATH9K_5GHZ_5470_5850	REG_RULE(5470-10, 5850+10, 40, 0, 30,\
+#define ATH9K_5GHZ_5470_5850	REG_RULE(5470-10, 5850+10, 80, 0, 30,\
 				NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS)
-#define ATH9K_5GHZ_5725_5850	REG_RULE(5725-10, 5850+10, 40, 0, 30,\
+#define ATH9K_5GHZ_5725_5850	REG_RULE(5725-10, 5850+10, 80, 0, 30,\
 				NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS)
 
 #define ATH9K_2GHZ_ALL		ATH9K_2GHZ_CH01_11, \
-- 
1.7.10.4

