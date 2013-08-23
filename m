Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:47061 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab3HWI7p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 04:59:45 -0400
Received: by mail-la0-f47.google.com with SMTP id eo20so268247lab.20
        for <linux-wireless@vger.kernel.org>; Fri, 23 Aug 2013 01:59:43 -0700 (PDT)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: [PATCH v2 14/16] wcn36xx: add Makefile
Date: Fri, 23 Aug 2013 10:58:17 +0200
Message-Id: <1377248299-21007-15-git-send-email-k.eugene.e@gmail.com> (sfid-20130823_105952_341477_0D21D7C7)
In-Reply-To: <1377248299-21007-1-git-send-email-k.eugene.e@gmail.com>
References: <1377248299-21007-1-git-send-email-k.eugene.e@gmail.com>
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

