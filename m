Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:16833 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbcBWMNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 07:13:38 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/2] staging: wilc1000: Revert "staging: wilc1000: remove spaces around '->'"
Date: Tue, 23 Feb 2016 21:10:54 +0900
Message-ID: <1456229454-16649-2-git-send-email-leo.kim@atmel.com> (sfid-20160223_131342_805768_20E04681)
In-Reply-To: <1456229454-16649-1-git-send-email-leo.kim@atmel.com>
References: <1456229454-16649-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit 6c2ab2398b88 ("staging: wilc1000: remove spaces around '->'").
It had applied from a incorrectly commit a1b56a4c5054
("staging: wilc1000: wilc_wfi_cfgoperations.c: removes unnecessary log messages").

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index a7aa3d2..0fd3a1e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1928,7 +1928,7 @@ static int start_ap(struct wiphy *wiphy, struct net_device *dev,
 
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(dev);
-	wl = vif ->wilc;
+	wl = vif->wilc;
 
 	s32Error = set_channel(wiphy, &settings->chandef);
 
-- 
1.9.1

