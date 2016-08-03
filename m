Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21676 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698AbcHCSqX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 14:46:23 -0400
Date: Wed, 3 Aug 2016 21:43:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Benjamin Berg <benjamin.berg@open-mesh.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net, kernel-janitors@vger.kernel.org
Subject: [patch] ath9k: indent an if statement
Message-ID: <20160803184339.GB775@mwanda> (sfid-20160803_204651_467755_3C4D389B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It looks like this code is correct, but it just needs to be indented a
bit.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a394622..eb00724 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -919,7 +919,7 @@ static void ath9k_vif_iter_set_beacon(struct ath9k_vif_iter_data *iter_data,
 	} else {
 		if (iter_data->primary_beacon_vif->type != NL80211_IFTYPE_AP &&
 		    vif->type == NL80211_IFTYPE_AP)
-		iter_data->primary_beacon_vif = vif;
+			iter_data->primary_beacon_vif = vif;
 	}
 
 	iter_data->beacons = true;
