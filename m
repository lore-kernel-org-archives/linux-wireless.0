Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:62002 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab3IVWmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Sep 2013 18:42:54 -0400
Received: by mail-lb0-f176.google.com with SMTP id y6so2125410lbh.35
        for <linux-wireless@vger.kernel.org>; Sun, 22 Sep 2013 15:42:53 -0700 (PDT)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: [PATCH v4 14/16] wcn36xx: add Kconfig
Date: Sun, 22 Sep 2013 23:42:11 +0100
Message-Id: <1379889733-6215-15-git-send-email-k.eugene.e@gmail.com> (sfid-20130923_005039_701260_1D9E9EBA)
In-Reply-To: <1379889733-6215-1-git-send-email-k.eugene.e@gmail.com>
References: <1379889733-6215-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

adding Kconfig

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
1.8.1.2

