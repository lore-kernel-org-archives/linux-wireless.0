Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab0DSJ02 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 05:26:28 -0400
Date: Mon, 19 Apr 2010 11:24:52 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	wey-yi.w.guy@intel.com, Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: document IEEE80211_CONF_CHANGE_QoS
Message-ID: <20100419092451.GA2696@dhcp-lab-161.englab.brq.redhat.com>
References: <1271338982-3157-1-git-send-email-sgruszka@redhat.com> <1271495090.5157.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1271495090.5157.4.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dcf3c5f..97b2222 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -610,6 +610,7 @@ enum ieee80211_conf_flags {
  * @IEEE80211_CONF_CHANGE_RETRY_LIMITS: retry limits changed
  * @IEEE80211_CONF_CHANGE_IDLE: Idle flag changed
  * @IEEE80211_CONF_CHANGE_SMPS: Spatial multiplexing powersave mode changed
+ * @IEEE80211_CONF_CHANGE_QoS: Quality of service was enabled or disabled
  */
 enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_SMPS		= BIT(1),
