Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:51320 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161023Ab2K3SRl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 13:17:41 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 2/2] mac80211: Fix typo in mac80211.h
Date: Fri, 30 Nov 2012 19:17:28 +0100
Message-Id: <1354299448-19928-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121130_191748_544508_B3D2170D)
In-Reply-To: <1354299448-19928-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1354299448-19928-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 include/net/mac80211.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index db7680a..5486bc2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -164,7 +164,7 @@ enum ieee80211_chanctx_change {
  *	active on the channel to receive MIMO transmissions
  * @rx_chains_dynamic: The number of RX chains that must be enabled
  *	after RTS/CTS handshake to receive SMPS MIMO transmissions;
- *	this will always be >= @rx_chains_always.
+ *	this will always be >= @rx_chains_static.
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *), size is determined in hw information.
  */
-- 
1.7.10.4

