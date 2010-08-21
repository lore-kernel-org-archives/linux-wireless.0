Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3697 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab0HUUjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Aug 2010 16:39:54 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/3] mac80211: trivial spelling fixes
Date: Sat, 21 Aug 2010 16:39:01 -0400
Message-Id: <1282423143-4121-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix spelling and readability of a few lines of kernel doc:

    s/issueing/issuing/g
    s/approriate/appropriate/g
    s/supported by simply/supported simply by/
    s/IEEE80211_HW_BEACON_FILTERING/IEEE80211_HW_BEACON_FILTER/g

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 include/net/mac80211.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2a18113..dcc8c2b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1242,8 +1242,8 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  * %IEEE80211_CONF_PS flag enabled means that the powersave mode defined in
  * IEEE 802.11-2007 section 11.2 is enabled. This is not to be confused
  * with hardware wakeup and sleep states. Driver is responsible for waking
- * up the hardware before issueing commands to the hardware and putting it
- * back to sleep at approriate times.
+ * up the hardware before issuing commands to the hardware and putting it
+ * back to sleep at appropriate times.
  *
  * When PS is enabled, hardware needs to wakeup for beacons and receive the
  * buffered multicast/broadcast frames after the beacon. Also it must be
@@ -1264,7 +1264,7 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  * there's data traffic and still saving significantly power in idle
  * periods.
  *
- * Dynamic powersave is supported by simply mac80211 enabling and disabling
+ * Dynamic powersave is simply supported by mac80211 enabling and disabling
  * PS based on traffic. Driver needs to only set %IEEE80211_HW_SUPPORTS_PS
  * flag and mac80211 will handle everything automatically. Additionally,
  * hardware having support for the dynamic PS feature may set the
@@ -2458,7 +2458,7 @@ void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
  *
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  *
- * When beacon filtering is enabled with %IEEE80211_HW_BEACON_FILTERING and
+ * When beacon filtering is enabled with %IEEE80211_HW_BEACON_FILTER and
  * %IEEE80211_CONF_PS is set, the driver needs to inform whenever the
  * hardware is not receiving beacons with this function.
  */
@@ -2469,7 +2469,7 @@ void ieee80211_beacon_loss(struct ieee80211_vif *vif);
  *
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  *
- * When beacon filtering is enabled with %IEEE80211_HW_BEACON_FILTERING, and
+ * When beacon filtering is enabled with %IEEE80211_HW_BEACON_FILTER, and
  * %IEEE80211_CONF_PS and %IEEE80211_HW_CONNECTION_MONITOR are set, the driver
  * needs to inform if the connection to the AP has been lost.
  *
-- 
1.7.1.1


