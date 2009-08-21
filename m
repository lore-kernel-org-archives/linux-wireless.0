Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:33960 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755550AbZHUONi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 10:13:38 -0400
Received: from ironport-out-1.rz.rwth-aachen.de ([134.130.5.40])
 by mta-2.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0KOQ00MZ9CURGK40@mta-2.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Fri, 21 Aug 2009 16:13:39 +0200 (CEST)
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@openwrt.org>,
	Arnd Hannemann <hannemann@nets.rwth-aachen.de>
Subject: [PATCH] mac80211: Remove unnused throughput field from minstrel_rate.
Date: Fri, 21 Aug 2009 16:11:30 +0200
Message-id: <1250863890-28690-1-git-send-email-hannemann@nets.rwth-aachen.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I noticed that the throughput field of the minstrel_rate struct is never used,
so remove it.

Signed-off-by: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
---
 net/mac80211/rc80211_minstrel.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_minstrel.h
index 869fe0e..38bf416 100644
--- a/net/mac80211/rc80211_minstrel.h
+++ b/net/mac80211/rc80211_minstrel.h
@@ -33,7 +33,6 @@ struct minstrel_rate {
 
 	/* per-rate throughput */
 	u32 cur_tp;
-	u32 throughput;
 
 	u64 succ_hist;
 	u64 att_hist;
-- 
1.5.4

