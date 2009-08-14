Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:47530 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900AbZHNUKd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 16:10:33 -0400
Received: by mail-fx0-f215.google.com with SMTP id 11so1368354fxm.39
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 13:10:34 -0700 (PDT)
Message-ID: <4A85C4BA.3070603@gmail.com>
Date: Fri, 14 Aug 2009 22:10:34 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: LP-PHY: Update TX gain override for a spec typo fix
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/phy_lp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 558224b..bf89173 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -747,7 +747,7 @@ static void lpphy_set_tx_gains(struct b43_wldev *dev,
 		b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFF7F, 1 << 7);
 		b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2, 0xBFFF, 1 << 14);
 	}
-	b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFFBF, 1 << 4);
+	b43_phy_maskset(dev, B43_LPPHY_RF_OVERRIDE_2, 0xFFBF, 1 << 6);
 }
 
 static void lpphy_rev0_1_set_rx_gain(struct b43_wldev *dev, u32 gain)
-- 
1.6.2.4



