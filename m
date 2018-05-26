Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:56654 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754989AbeEZPAX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 26 May 2018 11:00:23 -0400
From: Colin King <colin.king@canonical.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rsi: fix spelling mistake "Uknown" -> "Unknown"
Date: Sat, 26 May 2018 16:00:19 +0100
Message-Id: <20180526150019.10288-1-colin.king@canonical.com> (sfid-20180526_170035_546267_6C78C510)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in rsi_dbg message text

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index bfa7569c85bb..2ca7464b7fa3 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -1103,7 +1103,7 @@ static int rsi_mac80211_ampdu_action(struct ieee80211_hw *hw,
 		break;
 
 	default:
-		rsi_dbg(ERR_ZONE, "%s: Uknown AMPDU action\n", __func__);
+		rsi_dbg(ERR_ZONE, "%s: Unknown AMPDU action\n", __func__);
 		break;
 	}
 
-- 
2.17.0
