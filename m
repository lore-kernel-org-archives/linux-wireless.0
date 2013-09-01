Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:33758 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757512Ab3IAWs3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Sep 2013 18:48:29 -0400
Message-ID: <1378075707.1953.29.camel@joe-AO722> (sfid-20130902_004844_013432_86E553D4)
Subject: [PATCH net-hext] wireless: scan: Remove comment to
 compare_ether_addr
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Date: Sun, 01 Sep 2013 15:48:27 -0700
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function is being removed, so remove the reference to it.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/wireless/scan.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index ad1e406..eeb7148 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -465,10 +465,6 @@ static int cmp_bss(struct cfg80211_bss *a,
 		}
 	}
 
-	/*
-	 * we can't use compare_ether_addr here since we need a < > operator.
-	 * The binary return value of compare_ether_addr isn't enough
-	 */
 	r = memcmp(a->bssid, b->bssid, sizeof(a->bssid));
 	if (r)
 		return r;


