Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:60990 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965564AbcCNPbL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2016 11:31:11 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Kalle Valo <kvalo@codeaurora.org>, Jiri Kosina <trivial@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH trivial] mwifiex: Spelling s/minmum/minimum/, s/bandwidth/bandwith/
Date: Mon, 14 Mar 2016 16:31:10 +0100
Message-Id: <1457969470-23851-1-git-send-email-geert+renesas@glider.be> (sfid-20160314_163135_998627_53699FF4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/wireless/marvell/mwifiex/tdls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/tdls.c b/drivers/net/wireless/marvell/mwifiex/tdls.c
index 9275f9c3f869bbb0..b39bf8bd954a2c71 100644
--- a/drivers/net/wireless/marvell/mwifiex/tdls.c
+++ b/drivers/net/wireless/marvell/mwifiex/tdls.c
@@ -285,7 +285,7 @@ static int mwifiex_tdls_add_vht_oper(struct mwifiex_private *priv,
 	else
 		usr_vht_cap_info = adapter->usr_dot_11ac_dev_cap_bg;
 
-	/* find the minmum bandwith between AP/TDLS peers */
+	/* find the minimum bandwidth between AP/TDLS peers */
 	vht_cap = &sta_ptr->tdls_cap.vhtcap;
 	supp_chwd_set = GET_VHTCAP_CHWDSET(usr_vht_cap_info);
 	peer_supp_chwd_set =
-- 
1.9.1

