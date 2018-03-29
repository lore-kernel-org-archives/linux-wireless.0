Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42707 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751215AbeC2PiX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 11:38:23 -0400
From: Colin King <colin.king@canonical.com>
To: Solomon Peachy <pizza@shaftnet.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cw1200: fix spelling mistake: "Mailformed" -> "Malformed"
Date: Thu, 29 Mar 2018 16:38:18 +0100
Message-Id: <20180329153818.29538-1-colin.king@canonical.com> (sfid-20180329_173854_269722_2C032E0A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in wiphy_warn warning message text

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/st/cw1200/txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/st/cw1200/txrx.c b/drivers/net/wireless/st/cw1200/txrx.c
index e9050b41157a..f7b1b0062db3 100644
--- a/drivers/net/wireless/st/cw1200/txrx.c
+++ b/drivers/net/wireless/st/cw1200/txrx.c
@@ -1069,7 +1069,7 @@ void cw1200_rx_cb(struct cw1200_common *priv,
 	}
 
 	if (skb->len < sizeof(struct ieee80211_pspoll)) {
-		wiphy_warn(priv->hw->wiphy, "Mailformed SDU rx'ed. Size is lesser than IEEE header.\n");
+		wiphy_warn(priv->hw->wiphy, "Malformed SDU rx'ed. Size is lesser than IEEE header.\n");
 		goto drop;
 	}
 
-- 
2.15.1
