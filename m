Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34914 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab0DTGSh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 02:18:37 -0400
Date: Tue, 20 Apr 2010 08:16:37 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	wey-yi.w.guy@intel.com, Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>
Subject: [PATCH v2] mac80211: document IEEE80211_CONF_CHANGE_QOS
Message-ID: <20100420061636.GA2645@dhcp-lab-161.englab.brq.redhat.com>
References: <1271338982-3157-1-git-send-email-sgruszka@redhat.com> <1271495090.5157.4.camel@jlt3.sipsolutions.net> <20100419092451.GA2696@dhcp-lab-161.englab.brq.redhat.com> <1271692635.9026.17.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1271692635.9026.17.camel@mj>
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
+ * @IEEE80211_CONF_CHANGE_QOS: Quality of service was enabled or disabled
  */
 enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_SMPS		= BIT(1),
