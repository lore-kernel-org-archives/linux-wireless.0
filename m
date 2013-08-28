Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:60688 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab3H1H6C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 03:58:02 -0400
Received: by mail-lb0-f170.google.com with SMTP id r12so3564888lbi.29
        for <linux-wireless@vger.kernel.org>; Wed, 28 Aug 2013 00:58:01 -0700 (PDT)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: [PATCH v3 14/16] wcn36xx: add Makefile
Date: Wed, 28 Aug 2013 09:56:44 +0200
Message-Id: <1377676606-23033-15-git-send-email-k.eugene.e@gmail.com> (sfid-20130828_100909_860398_187C7BE1)
In-Reply-To: <1377676606-23033-1-git-send-email-k.eugene.e@gmail.com>
References: <1377676606-23033-1-git-send-email-k.eugene.e@gmail.com>
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

