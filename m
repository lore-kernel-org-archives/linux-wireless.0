Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.zhinst.com ([212.126.164.98]:53333 "EHLO mail.zhinst.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933247AbcALM0v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 07:26:51 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8xxxu: Fix typo in Kconfig help text
Date: Tue, 12 Jan 2016 13:26:48 +0100
Message-Id: <1452601608-11361-1-git-send-email-tklauser@distanz.ch> (sfid-20160112_132653_646841_AE198066)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix spelling of "benefits".

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/net/wireless/realtek/rtl8xxxu/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/Kconfig b/drivers/net/wireless/realtek/rtl8xxxu/Kconfig
index dd4d626aecbc..8f053c350227 100644
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
2.7.0.1.g5e091f5


