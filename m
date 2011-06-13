Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:39528 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab1FMWiE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:38:04 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh05-2.mail.saunalahti.fi (Postfix) with SMTP id 788EE8BE63
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:38:03 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh06.mail.saunalahti.fi (Postfix) with ESMTP id 62D54E51A2
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:38:02 +0300 (EEST)
Subject: [PATCH v2 23/27] mac80211: rename ieee80211_sdata_state_bits to
	mac80211_sdata_state_bits
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:38:01 +0300
Message-ID: <20110613223801.10517.762.stgit@localhost6.localdomain6> (sfid-20110614_005723_980811_577C163B)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/mac80211_i.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index df53135..3d1fe4f 100644
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

