Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:44362 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaJ3F4I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 01:56:08 -0400
Received: by mail-pa0-f48.google.com with SMTP id ey11so4731594pad.7
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 22:56:07 -0700 (PDT)
Date: Wed, 29 Oct 2014 22:55:58 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH net-next] mac80211: fix spelling errors
Message-ID: <20141029225558.1422bc2f@urahara> (sfid-20141030_065612_747173_F7FA5716)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use codespell to find spelling errors.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>


--- a/net/mac80211/cfg.c	2014-09-28 16:27:20.657506824 -0700
+++ b/net/mac80211/cfg.c	2014-10-27 20:39:21.207560433 -0700
@@ -190,7 +190,7 @@ static int ieee80211_add_key(struct wiph
 		 * receive the key. When wpa_supplicant has roamed
 		 * using FT, it attempts to set the key before
 		 * association has completed, this rejects that attempt
-		 * so it will set the key again after assocation.
+		 * so it will set the key again after association.
 		 *
 		 * TODO: accept the key if we have a station entry and
 		 *       add it to the device after the station.
--- a/net/mac80211/chan.c	2014-09-28 16:27:20.657506824 -0700
+++ b/net/mac80211/chan.c	2014-10-27 20:39:31.959544235 -0700
@@ -1634,7 +1634,7 @@ int ieee80211_vif_change_bandwidth(struc
 		}
 		break;
 	case IEEE80211_CHANCTX_WILL_BE_REPLACED:
-		/* TODO: Perhaps the bandwith change could be treated as a
+		/* TODO: Perhaps the bandwidth change could be treated as a
 		 * reservation itself? */
 		ret = -EBUSY;
 		goto out;
--- a/net/mac80211/ieee80211_i.h	2014-09-28 16:27:20.657506824 -0700
+++ b/net/mac80211/ieee80211_i.h	2014-10-27 20:34:20.639799015 -0700
@@ -131,7 +131,7 @@ enum ieee80211_bss_corrupt_data_flags {
  *
  * These are bss flags that are attached to a bss in the
  * @valid_data field of &struct ieee80211_bss.  They show which parts
- * of the data structure were recieved as a result of an un-corrupted
+ * of the data structure were received as a result of an un-corrupted
  * beacon/probe response.
  */
 enum ieee80211_bss_valid_data_flags {
--- a/net/mac80211/rc80211_minstrel.c	2014-09-28 16:27:20.661506846 -0700
+++ b/net/mac80211/rc80211_minstrel.c	2014-10-27 20:39:46.503525113 -0700
@@ -191,7 +191,7 @@ minstrel_update_stats(struct minstrel_pr
 		 * (1) if any success probabilitiy >= 95%, out of those rates
 		 * choose the maximum throughput rate as max_prob_rate
 		 * (2) if all success probabilities < 95%, the rate with
-		 * highest success probability is choosen as max_prob_rate */
+		 * highest success probability is chosen as max_prob_rate */
 		if (mrs->probability >= MINSTREL_FRAC(95, 100)) {
 			if (mrs->cur_tp >= mi->r[tmp_prob_rate].stats.cur_tp)
 				tmp_prob_rate = i;
--- a/net/mac802154/ieee802154_dev.c	2014-07-25 11:02:43.895028221 -0700
+++ b/net/mac802154/ieee802154_dev.c	2014-10-27 20:40:26.471487715 -0700
@@ -267,7 +267,7 @@ ieee802154_alloc_device(size_t priv_data
 	 * +-----------------------+
 	 *
 	 * Due to ieee802154 layer isn't aware of driver and MAC structures,
-	 * so lets allign them here.
+	 * so lets align them here.
 	 */
 
 	priv_size = ALIGN(sizeof(*priv), NETDEV_ALIGN) + priv_data_len;
