Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40958 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762823Ab2DLVck (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:32:40 -0400
Received: by pbcun15 with SMTP id un15so2840406pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 14:32:40 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>,
	Pavel Zubarev <pavel.zubarev@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org, ashok@cozybit.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] mac80211: Set the correct values for hwmp (1) and airtimeLinkMetric (1)
Date: Thu, 12 Apr 2012 14:32:20 -0700
Message-Id: <1334266343-3970-2-git-send-email-javier@cozybit.com> (sfid-20120412_233243_333738_87D8AC7B)
In-Reply-To: <1334266343-3970-1-git-send-email-javier@cozybit.com>
References: <1334266343-3970-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Per sections 8.4.2.100.2 and 8.4.2.100.3 of Std 802.11-2012

Reported-by: Shinichi Hotori <hotorinn@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/ieee80211.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index db84e2f..ce9af89 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1458,7 +1458,7 @@ enum {
  * be specified in a vendor specific information element
  */
 enum {
-	IEEE80211_PATH_PROTOCOL_HWMP = 0,
+	IEEE80211_PATH_PROTOCOL_HWMP = 1,
 	IEEE80211_PATH_PROTOCOL_VENDOR = 255,
 };
 
@@ -1470,7 +1470,7 @@ enum {
  * specified in a vendor specific information element
  */
 enum {
-	IEEE80211_PATH_METRIC_AIRTIME = 0,
+	IEEE80211_PATH_METRIC_AIRTIME = 1,
 	IEEE80211_PATH_METRIC_VENDOR = 255,
 };
 
-- 
1.7.5.4

