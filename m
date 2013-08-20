Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:41948 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab3HTRl5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 13:41:57 -0400
Received: by mail-lb0-f181.google.com with SMTP id o10so711871lbi.40
        for <linux-wireless@vger.kernel.org>; Tue, 20 Aug 2013 10:41:56 -0700 (PDT)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: [PATCH 14/16] wcn36xx: Add Makefile
Date: Tue, 20 Aug 2013 19:41:17 +0200
Message-Id: <1377020479-16935-15-git-send-email-k.eugene.e@gmail.com> (sfid-20130820_200909_066406_39B100F0)
In-Reply-To: <1377020479-16935-1-git-send-email-k.eugene.e@gmail.com>
References: <1377020479-16935-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding Makefile

Signed-off-by: Eugene Krasnikov <k.eugene.e@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/Makefile | 9 +++++++++
 1 file changed, 9 insertions(+)
 create mode 100644 drivers/net/wireless/ath/wcn36xx/Makefile

diff --git a/drivers/net/wireless/ath/wcn36xx/Makefile b/drivers/net/wireless/ath/wcn36xx/Makefile
new file mode 100644
index 0000000..3351185
--- /dev/null
+++ b/drivers/net/wireless/ath/wcn36xx/Makefile
@@ -0,0 +1,9 @@
+obj-$(CONFIG_WCN36XX) := wcn36xx.o
+wcn36xx-y += 	main.o \
+		dxe.o \
+		txrx.o \
+		smd.o \
+		pmc.o \
+		debug.o
+
+
-- 
1.8.2.2

