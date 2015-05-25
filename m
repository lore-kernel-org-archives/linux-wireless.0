Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbbEYLG0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 07:06:26 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t4PB6QGL019318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Mon, 25 May 2015 07:06:26 -0400
Received: from localhost (dhcp-27-129.brq.redhat.com [10.34.27.129])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id t4PB6PsA018631
	for <linux-wireless@vger.kernel.org>; Mon, 25 May 2015 07:06:26 -0400
Date: Mon, 25 May 2015 13:05:37 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: docs: fix cannot parse enum error
Message-ID: <20150525110536.GA27765@redhat.com> (sfid-20150525_130630_793606_E0893D86)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch fixes documentation generation error:

Error(./include/net/mac80211.h:331): Cannot parse enum!
Error(./include/net/mac80211.h:369): Cannot parse enum!

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 include/net/mac80211.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8e3668b..1b8328c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -354,7 +354,7 @@ enum ieee80211_rssi_event_data {
 };
 
 /**
- * enum ieee80211_rssi_event - data attached to an %RSSI_EVENT
+ * struct ieee80211_rssi_event - data attached to an %RSSI_EVENT
  * @data: See &enum ieee80211_rssi_event_data
  */
 struct ieee80211_rssi_event {
@@ -388,7 +388,7 @@ enum ieee80211_mlme_event_status {
 };
 
 /**
- * enum ieee80211_mlme_event - data attached to an %MLME_EVENT
+ * struct ieee80211_mlme_event - data attached to an %MLME_EVENT
  * @data: See &enum ieee80211_mlme_event_data
  * @status: See &enum ieee80211_mlme_event_status
  * @reason: the reason code if applicable
-- 
1.7.1
