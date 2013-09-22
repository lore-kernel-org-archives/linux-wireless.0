Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:53043 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab3IVWmz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Sep 2013 18:42:55 -0400
Received: by mail-lb0-f175.google.com with SMTP id y6so2139852lbh.34
        for <linux-wireless@vger.kernel.org>; Sun, 22 Sep 2013 15:42:54 -0700 (PDT)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Subject: [PATCH v4 15/16] wcn36xx: add Makefile
Date: Sun, 22 Sep 2013 23:42:12 +0100
Message-Id: <1379889733-6215-16-git-send-email-k.eugene.e@gmail.com> (sfid-20130923_004831_284402_CB81C948)
In-Reply-To: <1379889733-6215-1-git-send-email-k.eugene.e@gmail.com>
References: <1379889733-6215-1-git-send-email-k.eugene.e@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

adding Makefile

Signed-off-by: Eugene Krasnikov <k.eugene.e@gmail.com>
---
 drivers/net/wireless/ath/wcn36xx/Makefile | 7 +++++++
 1 file changed, 7 insertions(+)
 create mode 100644 drivers/net/wireless/ath/wcn36xx/Makefile

diff --git a/drivers/net/wireless/ath/wcn36xx/Makefile b/drivers/net/wireless/ath/wcn36xx/Makefile
new file mode 100644
index 0000000..50c43b4
--- /dev/null
+++ b/drivers/net/wireless/ath/wcn36xx/Makefile
@@ -0,0 +1,7 @@
+obj-$(CONFIG_WCN36XX) := wcn36xx.o
+wcn36xx-y +=   main.o \
+               dxe.o \
+               txrx.o \
+               smd.o \
+               pmc.o \
+               debug.o
-- 
1.8.1.2

