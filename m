Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3695 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab0HUUjw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Aug 2010 16:39:52 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/3] ath5k: trivial spelling fixes
Date: Sat, 21 Aug 2010 16:39:02 -0400
Message-Id: <1282423143-4121-2-git-send-email-me@bobcopeland.com>
In-Reply-To: <1282423143-4121-1-git-send-email-me@bobcopeland.com>
References: <1282423143-4121-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix some comments:
    s/transmition/transmission/
    s/puting/putting/

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/pcu.c   |    4 ++--
 drivers/net/wireless/ath/ath5k/phy.c   |    2 +-
 drivers/net/wireless/ath/ath5k/reset.c |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 3fef593..bb2e215 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -137,11 +137,11 @@ void ath5k_hw_update_mib_counters(struct ath5k_hw *ah)
  * ath5k_hw_set_ack_bitrate - set bitrate for ACKs
  *
  * @ah: The &struct ath5k_hw
- * @high: Flag to determine if we want to use high transmition rate
+ * @high: Flag to determine if we want to use high transmission rate
  * for ACKs or not
  *
  * If high flag is set, we tell hw to use a set of control rates based on
- * the current transmition rate (check out control_rates array inside reset.c).
+ * the current transmission rate (check out control_rates array inside reset.c).
  * If not hw just uses the lowest rate available for the current modulation
  * scheme being used (1Mbit for CCK and 6Mbits for OFDM).
  */
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index c7c4465..8c27a36 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -2987,7 +2987,7 @@ ath5k_setup_rate_powertable(struct ath5k_hw *ah, u16 max_pwr,
 
 
 /*
- * Set transmition power
+ * Set transmission power
  */
 int
 ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 4154959..58912cd 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -326,7 +326,7 @@ commit:
  * register). After this MAC and Baseband are
  * disabled and a full reset is needed to come
  * back. This way we save as much power as possible
- * without puting the card on full sleep.
+ * without putting the card on full sleep.
  */
 int ath5k_hw_on_hold(struct ath5k_hw *ah)
 {
@@ -344,7 +344,7 @@ int ath5k_hw_on_hold(struct ath5k_hw *ah)
 	/*
 	 * Put chipset on warm reset...
 	 *
-	 * Note: puting PCI core on warm reset on PCI-E cards
+	 * Note: putting PCI core on warm reset on PCI-E cards
 	 * results card to hang and always return 0xffff... so
 	 * we ingore that flag for PCI-E cards. On PCI cards
 	 * this flag gets cleared after 64 PCI clocks.
@@ -400,7 +400,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 	/*
 	 * Put chipset on warm reset...
 	 *
-	 * Note: puting PCI core on warm reset on PCI-E cards
+	 * Note: putting PCI core on warm reset on PCI-E cards
 	 * results card to hang and always return 0xffff... so
 	 * we ingore that flag for PCI-E cards. On PCI cards
 	 * this flag gets cleared after 64 PCI clocks.
-- 
1.7.1.1


