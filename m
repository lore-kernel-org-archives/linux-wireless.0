Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbcB2WGD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 105/113] rtl8xxxu: Remove unncessary semicolon
Date: Mon, 29 Feb 2016 17:05:43 -0500
Message-Id: <1456783551-28315-106-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232951_688318_7084D714)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This removes an superfluous semicolon.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 8cb76e2..67ea89b 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7195,7 +7195,7 @@ static void rtl8xxxu_tx(struct ieee80211_hw *hw,
 			tx_desc->txdw3 |=
 				cpu_to_le32(TXDESC_HW_RTS_ENABLE_8723B);
 		}
-	};
+	}
 
 	rtl8xxxu_calc_tx_desc_csum(tx_desc);
 
-- 
2.5.0

