Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:41204 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab1E2UGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2011 16:06:50 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh01-2.mail.saunalahti.fi (Postfix) with SMTP id 772808C65E
	for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 23:06:49 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh07.mail.saunalahti.fi (Postfix) with ESMTP id 609581C6385
	for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 23:06:48 +0300 (EEST)
Subject: [RFC PATCH 23/27] mac80211: rename ieee80211_sdata_state_bits to
	mac80211_sdata_state_bits
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 29 May 2011 23:06:47 +0300
Message-ID: <20110529200647.16479.17618.stgit@localhost6.localdomain6> (sfid-20110529_220653_595980_D4FAE6E0)
In-Reply-To: <20110529195022.16479.71762.stgit@localhost6.localdomain6>
References: <20110529195022.16479.71762.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/mac80211_i.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index 5ae43dc..dfc3f77 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -524,14 +524,14 @@ enum mac80211_sub_if_data_flags {
 };
 
 /**
- * enum ieee80211_sdata_state_bits - virtual interface state bits
+ * enum mac80211_sdata_state_bits - virtual interface state bits
  * @SDATA_STATE_RUNNING: virtual interface is up & running; this
  *	mirrors netif_running() but is separate for interface type
  *	change handling while the interface is up
  * @SDATA_STATE_OFFCHANNEL: This interface is currently in offchannel
  *	mode, so queues are stopped
  */
-enum ieee80211_sdata_state_bits {
+enum mac80211_sdata_state_bits {
 	SDATA_STATE_RUNNING,
 	SDATA_STATE_OFFCHANNEL,
 };

