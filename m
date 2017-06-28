Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:39726 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751512AbdF1Pu7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 11:50:59 -0400
From: Colin King <colin.king@canonical.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mwifiex: fix spelling mistake: "secuirty" -> "security"
Date: Wed, 28 Jun 2017 16:50:54 +0100
Message-Id: <20170628155054.27885-1-colin.king@canonical.com> (sfid-20170628_175132_894628_8689B30B)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in mwifiex_dbg message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index a850ec0054e2..d8ff823c0818 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1981,7 +1981,7 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 
 	if (mwifiex_set_secure_params(priv, bss_cfg, params)) {
 		mwifiex_dbg(priv->adapter, ERROR,
-			    "Failed to parse secuirty parameters!\n");
+			    "Failed to parse security parameters!\n");
 		goto out;
 	}
 
-- 
2.11.0
