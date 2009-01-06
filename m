Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:3711 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbZAFIvS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 03:51:18 -0500
Received: by nf-out-0910.google.com with SMTP id d3so953319nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 00:51:16 -0800 (PST)
Message-ID: <eb3ff54b0901060051t7fcf2851s7d99cdd2a0f6620c@mail.gmail.com> (sfid-20090106_095120_795233_E57BB3E9)
Date: Tue, 6 Jan 2009 10:51:16 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH 4/6] mac80211: remove unused declarations in rx.c.
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes four unused declarations in rx.c (of mac1..mac4).

(wireless-testing).

Signed-off-by: Rami Rosen <ramirose@gmail.com>

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 384cb3b..c208b73 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1125,10 +1125,6 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
 	u8 src[ETH_ALEN] __aligned(2);
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	DECLARE_MAC_BUF(mac);
-	DECLARE_MAC_BUF(mac2);
-	DECLARE_MAC_BUF(mac3);
-	DECLARE_MAC_BUF(mac4);

 	if (unlikely(!ieee80211_is_data_present(hdr->frame_control)))
 		return -1;
