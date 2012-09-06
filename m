Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57247 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab2IFQJr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 12:09:47 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: kernel-janitors@vger.kernel.org,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 8/10] net/mac80211/scan.c: removes unnecessary semicolon
Date: Thu,  6 Sep 2012 18:09:16 +0200
Message-Id: <1346947757-10481-9-git-send-email-peter.senna@gmail.com> (sfid-20120906_181141_727521_59BA9FFD)
In-Reply-To: <1346947757-10481-1-git-send-email-peter.senna@gmail.com>
References: <1346947757-10481-1-git-send-email-peter.senna@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 net/mac80211/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/net/mac80211/scan.c b/net/mac80211/scan.c
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -407,7 +407,7 @@ static void ieee80211_scan_state_send_pr
 	enum ieee80211_band band = local->hw.conf.channel->band;
 
 	sdata = rcu_dereference_protected(local->scan_sdata,
-					  lockdep_is_held(&local->mtx));;
+					  lockdep_is_held(&local->mtx));
 
 	for (i = 0; i < local->scan_req->n_ssids; i++)
 		ieee80211_send_probe_req(

