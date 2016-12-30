Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:40021 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754161AbcL3OHj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 09:07:39 -0500
From: Colin King <colin.king@canonical.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k: fix spelling mistake: "meaurement" -> "measurement"
Date: Fri, 30 Dec 2016 14:06:47 +0000
Message-Id: <20161230140647.12945-1-colin.king@canonical.com> (sfid-20161230_150812_595868_84232743)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in ath_err message

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a35f78b..ac36873 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -731,7 +731,7 @@ u32 ar9003_get_pll_sqsum_dvc(struct ath_hw *ah)
 		udelay(100);
 
 		if (WARN_ON_ONCE(i >= 100)) {
-			ath_err(common, "PLL4 meaurement not done\n");
+			ath_err(common, "PLL4 measurement not done\n");
 			break;
 		}
 
-- 
2.10.2
