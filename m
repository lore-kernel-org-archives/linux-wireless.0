Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:41925 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab3HWI7q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 04:59:46 -0400
Received: by mail-la0-f49.google.com with SMTP id ev20so276010lab.22
        for <linux-wireless@vger.kernel.org>; Fri, 23 Aug 2013 01:59:45 -0700 (PDT)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: [PATCH v2 15/16] wcn36xx: add Kconfig
Date: Fri, 23 Aug 2013 10:58:18 +0200
Message-Id: <1377248299-21007-16-git-send-email-k.eugene.e@gmail.com> (sfid-20130823_105953_609456_09AA55BF)
In-Reply-To: <1377248299-21007-1-git-send-email-k.eugene.e@gmail.com>
References: <1377248299-21007-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding Kconfig

Signed-off-by: Eugene Krasnikov <k.eugene.e@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/Kconfig | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 drivers/net/wireless/ath/wcn36xx/Kconfig

diff --git a/drivers/net/wireless/ath/wcn36xx/Kconfig b/drivers/net/wireless/ath/wcn36xx/Kconfig
new file mode 100644
index 0000000..591ebae
--- /dev/null
+++ b/drivers/net/wireless/ath/wcn36xx/Kconfig
@@ -0,0 +1,16 @@
+config WCN36XX
+	tristate "Qualcomm Atheros WCN3660/3680 support"
+	depends on MAC80211 && HAS_DMA
+	---help---
+	  This module adds support for wireless adapters based on
+	  Qualcomm Atheros WCN3660 and WCN3680 mobile chipsets.
+
+	  If you choose to build a module, it'll be called wcn36xx.
+
+config WCN36XX_DEBUGFS
+	bool "WCN36XX debugfs support"
+	depends on WCN36XX
+	---help---
+	  Enabled debugfs support
+
+	  If unsure, say Y to make it easier to debug problems.
-- 
1.8.2.2

