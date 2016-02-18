Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:40437 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574AbcBRHcD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 02:32:03 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH 13/24] staging: wilc1000: wilc_wfi_cfgoperations.c: removes unnecessary log messages
Date: Thu, 18 Feb 2016 16:27:24 +0900
Message-ID: <1455780455-21365-13-git-send-email-leo.kim@atmel.com> (sfid-20160218_083228_431873_036E85C0)
In-Reply-To: <1455780455-21365-1-git-send-email-leo.kim@atmel.com>
References: <1455780455-21365-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch removes unnecessary log messages.
And, it adds a 'break' statement in accordance with the switch-case rule.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 9c46c6b..030566e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -795,7 +795,7 @@ static int connect(struct wiphy *wiphy, struct net_device *dev,
 		break;
 
 	default:
-		PRINT_D(CFG80211_DBG, "Automatic Authentation type = %d\n", sme->auth_type);
+		break;
 	}
 
 	if (sme->crypto.n_akm_suites) {
-- 
1.9.1

