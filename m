Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:50381 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751828AbdGMWsd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Jul 2017 18:48:33 -0400
From: Colin King <colin.king@canonical.com>
To: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] zd1211rw: fix spelling mistake 'hybernate' -> 'hibernate'
Date: Thu, 13 Jul 2017 23:48:29 +0100
Message-Id: <20170713224829.15459-1-colin.king@canonical.com> (sfid-20170714_004903_302366_3FBFA62C)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in PDEBUG debug message.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/zydas/zd1211rw/zd_rf_rf2959.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_rf_rf2959.c b/drivers/net/wireless/zydas/zd1211rw/zd_rf_rf2959.c
index a93f657a41c7..d4e512f50945 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_rf_rf2959.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_rf_rf2959.c
@@ -61,7 +61,7 @@ static void dump_regwrite(u32 rw)
 
 	switch (reg) {
 	case 0:
-		PDEBUG("reg0 CFG1 ref_sel %d hybernate %d rf_vco_reg_en %d"
+		PDEBUG("reg0 CFG1 ref_sel %d hibernate %d rf_vco_reg_en %d"
 		       " if_vco_reg_en %d if_vga_en %d",
 		       bits(rw, 14, 15), bit(rw, 3), bit(rw, 2), bit(rw, 1),
 		       bit(rw, 0));
-- 
2.11.0
