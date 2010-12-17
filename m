Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50385 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab0LQOAF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 09:00:05 -0500
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1PTaqq-0004ve-CV
	for linux-wireless@vger.kernel.org; Fri, 17 Dec 2010 09:00:04 -0500
Received: from linville-8530p.local (localhost.localdomain [127.0.0.1])
	by linville-8530p.local (8.14.4/8.14.4) with ESMTP id oBHDxelH002649
	for <linux-wireless@vger.kernel.org>; Fri, 17 Dec 2010 08:59:40 -0500
Received: (from linville@localhost)
	by linville-8530p.local (8.14.4/8.14.4/Submit) id oBHDxd0Z002648
	for linux-wireless@vger.kernel.org; Fri, 17 Dec 2010 08:59:39 -0500
From: Anisse Astier <anisse@astier.eu>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W\. Linville" <linville@tuxdriver.com>,
	Anisse Astier <anisse@astier.eu>
Subject: [PATCH] rtl8192ce: Fix typo in Kconfig description
Date: Fri, 17 Dec 2010 11:45:01 +0100
Message-Id: <1292582701-18972-1-git-send-email-anisse@astier.eu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Anisse Astier <anisse@astier.eu>
---
 drivers/net/wireless/rtlwifi/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/Kconfig b/drivers/net/wireless/rtlwifi/Kconfig
index d712026..7f6573f 100644
--- a/drivers/net/wireless/rtlwifi/Kconfig
+++ b/drivers/net/wireless/rtlwifi/Kconfig
@@ -7,7 +7,7 @@ config RTL8192CE
 	This is the driver for Realtek RTL8192CE/RTL8188CE 802.11n PCIe
 	wireless network adapters.
 
-	If you choose to build it as a module, it will be calledrtl8192ce.
+	If you choose to build it as a module, it will be called rtl8192ce
 
 config RTLWIFI
 	tristate
-- 
1.7.3.2


