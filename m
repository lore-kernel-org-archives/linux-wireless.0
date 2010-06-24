Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41975 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab0FXPaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 11:30:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] minstrel_ht: mark minstrel_mcs_groups as static
Date: Thu, 24 Jun 2010 11:16:42 -0400
Message-Id: <1277392602-10578-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/rc80211_minstrel_ht.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 7a04951..a8f658c 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -59,7 +59,7 @@
  * groups, based on the number of streams and flags (HT40, SGI) that they
  * use.
  */
-const struct mcs_group minstrel_mcs_groups[] = {
+static const struct mcs_group minstrel_mcs_groups[] = {
 	MCS_GROUP(1, 0, 0),
 	MCS_GROUP(2, 0, 0),
 #if MINSTREL_MAX_STREAMS >= 3
-- 
1.7.0.1

