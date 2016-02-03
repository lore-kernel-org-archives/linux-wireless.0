Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965916AbcBCSkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Tobias Klauser <tklauser@distanz.ch>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 08/28] rtl8xxxu: Fix typo in Kconfig help text
Date: Wed,  3 Feb 2016 13:39:42 -0500
Message-Id: <1454524802-26763-9-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_194801_859484_743F962A)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tobias Klauser <tklauser@distanz.ch>

Fix spelling of "benefits".

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/Kconfig b/drivers/net/wireless/realtek/rtl8xxxu/Kconfig
index dd4d626..8f053c3 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/Kconfig
+++ b/drivers/net/wireless/realtek/rtl8xxxu/Kconfig
@@ -13,7 +13,7 @@ config RTL8XXXU
 	  This driver is under development and has a limited feature
 	  set. In particular it does not yet support 40MHz channels
 	  and power management. However it should have a smaller
-	  memory footprint than the vendor drivers and benetifs
+	  memory footprint than the vendor drivers and benefits
 	  from the in kernel mac80211 stack.
 
 	  It can coexist with drivers from drivers/staging/rtl8723au,
-- 
2.5.0

