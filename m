Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:45967
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753220Ab3H1ARS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 20:17:18 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: linux-wireless@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>
Subject: [PATCH 1/2] cw1200: Display the correct default reference clock.
Date: Tue, 27 Aug 2013 20:17:12 -0400
Message-Id: <1377649033-2091-1-git-send-email-pizza@shaftnet.org> (sfid-20130828_021721_292728_6A66EAEF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is purely a cosmetic bug.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
---
 drivers/net/wireless/cw1200/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/cw1200/main.c b/drivers/net/wireless/cw1200/main.c
index 3724e73..090f015 100644
--- a/drivers/net/wireless/cw1200/main.c
+++ b/drivers/net/wireless/cw1200/main.c
@@ -507,7 +507,7 @@ u32 cw1200_dpll_from_clk(u16 clk_khz)
 	case 0xCB20: /* 52000 KHz */
 		return 0x07627091;
 	default:
-		pr_err("Unknown Refclk freq (0x%04x), using 2600KHz\n",
+		pr_err("Unknown Refclk freq (0x%04x), using 26000KHz\n",
 		       clk_khz);
 		return 0x0EC4F121;
 	}
-- 
1.8.3.1

