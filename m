Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:48884 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbaFDMJh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 08:09:37 -0400
From: Antonio Ospite <ao2@ao2.it>
To: Jiri Kosina <trivial@kernel.org>
Cc: Antonio Ospite <ao2@ao2.it>, Luis Carlos Cobo <luisca@cozybit.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 11/12] trivial: net/mac80211/mesh.c: fix typo s/Substract/Subtract/
Date: Wed,  4 Jun 2014 14:03:49 +0200
Message-Id: <1401883430-19492-12-git-send-email-ao2@ao2.it> (sfid-20140604_140940_756016_B25121D1)
In-Reply-To: <1401883430-19492-1-git-send-email-ao2@ao2.it>
References: <1401883430-19492-1-git-send-email-ao2@ao2.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Antonio Ospite <ao2@ao2.it>
Cc: Luis Carlos Cobo <luisca@cozybit.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
---
 net/mac80211/mesh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index f70e9cd..515cb4a 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1126,7 +1126,7 @@ static int mesh_fwd_csa_frame(struct ieee80211_sub_if_data *sdata,
 	mgmt_fwd = (struct ieee80211_mgmt *) skb_put(skb, len);
 
 	/* offset_ttl is based on whether the secondary channel
-	 * offset is available or not. Substract 1 from the mesh TTL
+	 * offset is available or not. Subtract 1 from the mesh TTL
 	 * and disable the initiator flag before forwarding.
 	 */
 	offset_ttl = (len < 42) ? 7 : 10;
-- 
2.0.0

